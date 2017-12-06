echoerr() {
  >&2 echo -e "\033[0;31m$1\033[0m"
}

ensure_ruby_build_available() {
  if [ ! -x "$(command -v ruby-build)" ]; then
    echoerr "Please install ruby-build first"
    echoerr "See https://github.com/rbenv/ruby-build#installation"
    exit 1
  fi
}
