RUBY_INSTALL_VERSION="${ASDF_RUBY_INSTALL_VERSION:-v0.8.1}"

echoerr() {
  >&2 echo -e "\033[0;31m$1\033[0m"
}

ensure_ruby_install_setup() {
  ensure_ruby_install_installed
}

ensure_ruby_install_installed() {
  # If ruby-install exists
  if [ -x "$(ruby_install_path)" ]; then
    # But was passed an expected version
    if [ -n "${ASDF_RUBY_INSTALL_VERSION:-}" ]; then
      current_ruby_install_version="v$("$(ruby_install_path)" --version | cut -d ' ' -f2)"
      # Check if expected version matches current version
      if [ "$current_ruby_install_version" != "$RUBY_INSTALL_VERSION" ]; then
        # If not reinstall and checkout ASDF_RUBY_INSTALL_VERSION
        rm -rf "$(ruby_install_dir)"
        download_ruby_install
      fi
    fi
  else
    # ruby-install does not exist, so install using default value in RUBY_INSTALL_VERSION
    download_ruby_install
  fi
}



download_ruby_install() {
  # Print to stderr so asdf doesn't assume this string is a list of versions
  echoerr "Downloading ruby-install $RUBY_INSTALL_VERSION"
  local build_dir="$(ruby_install_source_dir)"

  # Remove directory in case it still exists from last download
  rm -rf "$build_dir"

  # Clone down and checkout the correct ruby-install version
  git clone https://github.com/postmodern/ruby-install.git "$build_dir" --quiet
  (cd "$build_dir"; git checkout $RUBY_INSTALL_VERSION --quiet;)

  echo "$(cd $build_dir; PREFIX=$(ruby_install_dir) make install)" 2>&1 >/dev/null

  rm -rf "$build_dir"
}

asdf_ruby_plugin_path() {
  echo "$(dirname "$(dirname "$0")")"
}
ruby_install_dir() {
  echo "$(asdf_ruby_plugin_path)/ruby-install"
}

ruby_install_source_dir() {
  echo "$(asdf_ruby_plugin_path)/ruby-install-source"
}


ruby_install_path() {
  #Check if ruby-install exists without an expected version
  if [ -x "$(command -v ruby-install)" ] && [ -z "${ASDF_RUBY_INSTALL_VERSION:-}" ]; then
    echo "$(command -v ruby-install)"
  else
    echo "$(ruby_install_dir)/bin/ruby-install"
  fi
}
