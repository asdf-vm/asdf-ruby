echoerr() {
  printf "\033[0;31m%s\033[0m" "$1" >&2
}

abspath() {
    cd "$(dirname "$1")"
    printf "%s/%s\n" "$(pwd)" "$(basename "$1")"
}

ensure_ruby_build_installed() {
  if [ ! -d "$(ruby_build_root)" ]; then
    download_ruby_build
  fi
}

download_ruby_build() {
  echo "Downloading ruby-build..."
  local ruby_build_url="https://github.com/rbenv/ruby-build.git"
  git clone $ruby_build_url "$(ruby_build_root)"
}

ruby_build_root() {
  echo "$(dirname "$(dirname "$0")")/ruby-build"
}

ruby_build_path() {
  echo "$(ruby_build_root)/bin/ruby-build"
}
