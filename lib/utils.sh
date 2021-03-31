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
