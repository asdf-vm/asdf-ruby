  export RUBY_INSTALL_VERSION="${ASDF_RUBY_INSTALL_VERSION:-v0.8.1}"

printerr() {
  >&2 printf '\033[0;31m%s\033[0m \n' "$1"
}

ensure_ruby_install_setup() {
  ensure_ruby_install_installed
}

ensure_ruby_install_installed() {
  # If ruby-install exists
  if [ -x "$(ruby_install_executable)" ]; then
    # But was passed an expected version
    if [ -n "${ASDF_RUBY_INSTALL_VERSION:-}" ]; then
      current_ruby_install_version="v$("$(ruby_install_executable)" --version | cut -d ' ' -f2)"
      # Check if expected version matches current version
      if [ "$current_ruby_install_version" != "$RUBY_INSTALL_VERSION" ]; then
        # If not, reinstall with ASDF_RUBY_INSTALL_VERSION
        download_ruby_install
      fi
    fi
  else
    # ruby-install does not exist, so install using default value in RUBY_INSTALL_VERSION
    download_ruby_install
  fi
}



download_ruby_install() {
  # Remove directory in case it still exists from last download
  rm -rf "$(ruby_install_source_path)"
  rm -rf "$(ruby_install_path)"
  # Print to stderr so asdf doesn't assume this string is a list of versions
  printerr "Downloading ruby-install $RUBY_INSTALL_VERSION"



  # Clone down and checkout the correct ruby-install version
  git clone https://github.com/postmodern/ruby-install.git "$(ruby_install_source_path)" --quiet
  (cd "$(ruby_install_source_path)"; git checkout $RUBY_INSTALL_VERSION --quiet;)

  echo "$(cd $(ruby_install_source_path); PREFIX=$(ruby_install_path) make install)" 2>&1 >/dev/null

  rm -rf "$(ruby_install_source_path)"
}

asdf_ruby_plugin_path() {
  echo "$(dirname "$(dirname "$0")")"
}

plugin_name() {
  basename $(asdf_ruby_plugin_path)
}

ruby_install_path() {
  echo "$(asdf_ruby_plugin_path)/ruby-install"
}

ruby_install_source_path() {
  echo "$(ruby_install_path)-source"
}


ruby_install_executable() {
  #Check if ruby-install exists without an expected version
  if [ -x "$(command -v ruby-install)" ] && [ -z "${ASDF_RUBY_INSTALL_VERSION:-}" ]; then
    echo "$(command -v ruby-install)"
  else
    echo "$(ruby_install_path)/bin/ruby-install"
  fi
}

get_macos_marketing_name() {
  if [ "$(uname -s)" = "Darwin" ]; then
    osx_num=$(SYSTEM_VERSION_COMPAT=1 sw_vers -productVersion | awk -F '[.]' '{print $2}')
    OSX_MARKETING=(
        ["10"]="yosemite"
        ["11"]="el_capitan"
        ["12"]="sierra"
        ["13"]="high_sierra"
        ["14"]="mojave"
        ["15"]="catalina"
        ["16"]="big_sur"
      )

    if [[ -n "${OSX_MARKETING[$osx_num]}" ]]; then 
      printf '%s\n' "${OSX_MARKETING[$osx_num]}"
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

macos_get_download_url() {
  local os_name=$(
      if [ "$(uname -m)" = "arm64" ]; then 
        printf "arm64_%s" "$1"
      else
        printf "%s" "$1"
      fi
    )

  printf 'Looking for prebuilt %s %s on %s. \n' "$(plugin_name)" "$ASDF_INSTALL_VERSION" "$os_name" >&2
  local ruby_version="ruby-$ASDF_INSTALL_VERSION"
  local file_name="$ruby_version.$os_name.bottle.tar.gz"
  local url="https://bintray.com/homebrew/bottles/download_file?file_path=$file_name"

  if curl --output /dev/null --silent --head --fail "$url"; then
    printf '%s' $url
    return 0
  else
    printerr 'No prebuilt %s %s for %s is available. ' "$(plugin_name)" "$ASDF_INSTALL_VERSION" "$os_name"
    return 1
  fi
}

macos_update_linked_paths() {
  
  local file_paths=("$@")
  
  local brew_prefix="$(brew --prefix)"
  local replacement_cellar="@@HOMEBREW_CELLAR@@/ruby/$ASDF_INSTALL_VERSION"

  local replacement_prefix="@@HOMEBREW_PREFIX@@"
  

  for file in "${file_paths[@]}"; do

    local changes=()
    for line in $(otool -L "$file"); do
      if [[ "$line" == "$replacement_cellar"* ]]; then
        local result="${line/$replacement_cellar/$ASDF_INSTALL_PATH}"
        changes+=("-change" "$line" "$result")
      fi
      if [[ "$line" == "$replacement_prefix"* ]]; then
        local result="${line/$replacement_prefix/$brew_prefix}"
        changes+=("-change" "$line" "$result")
      fi
    done
    local command=(install_name_tool "${changes[@]}" "$file")
    "${command[@]}"

    # https://github.com/Homebrew/brew/blob/565becc90433df57c9ec6262dec1f41797fb680b/Library/Homebrew/os/mac/keg.rb#L21
    cp "$file" "$file.backup"
    codesign -s - -f -vvvvvv "$file.backup"
    mv -f "$file.backup" "$file"
  done




}

macos_check_homebrew_setup() {
  
  local brew_function="${1:-PREBUILT}"
  
  printf 'Checking Homebrew for dependencies. \n'
  if [ -x "$(command -v brew)" ]; then
    if [ ! -d "$(brew --prefix openssl)" ]; then
      printerr 'Missing openssl from Homebrew'
      printf 'Fix with: brew install openssl \n'
      exit 1
    fi
    if [ ! -d "$(brew --prefix readline)" ]; then
      printerr 'Missing wxmac from Homebrew'
      printf 'Fix with: brew install readline \n'
      exit 1
    fi
    return 0
  else
      printerr 'Homebrew is not installed or in PATH'
      printf 'To install without Homebrew, set your own KERL_CONFIGURE_OPTIONS \n'
      exit 1
  fi
}
