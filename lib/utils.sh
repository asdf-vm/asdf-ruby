RUBY_BUILD_VERSION="20180424"
RUBY_BUILD_TAG="v$RUBY_BUILD_VERSION"

echoerr() {
  >&2 echo -e "\033[0;31m$1\033[0m"
}

ensure_ruby_build_setup() {
  #set_ruby_build_env
  ensure_ruby_build_installed
}

ensure_ruby_build_installed() {
    echo "got here"
    if [ ! -f "$(ruby_build_path)" ]; then
        download_ruby_build
    else
        local ruby_build_version="$("$(ruby_build_path)" --version | cut -d ' ' -f2)"
        echo $ruby_build_version
        if [ "$("$(ruby_build_path)" --version)" != "$RUBY_BUILD_VERSION" ]; then
            # If the ruby-build directory already exists and the version does not
            # match, remove it and download the correct version
            rm -rf "$(ruby_build_dir)"
            download_ruby_build
        fi
    fi
}

download_ruby_build() {
    # Print to stderr so asdf doesn't assume this string is a list of versions
    echo "Downloading ruby-build..." >&2
    local build_dir="ruby-build-source"

    # Clone down and checkout the correct ruby-build version
    git clone https://github.com/rbenv/ruby-build.git $build_dir >&2 >/dev/null
    $(cd $build_dir; git checkout $RUBY_BUILD_TAG)

    # Install in the ruby-build dir
    PREFIX="$(ruby_build_dir)" ./$build_dir/install.sh

    # Remove ruby-build source dir
    rm -rf ruby-build-source
}

ruby_build_dir() {
    echo "$(dirname "$(dirname $0)")/ruby-build"
}
ruby_build_path() {
    echo "$(ruby_build_dir)/bin/ruby-build"
}

#set_ruby_build_env() {
#    local kerl_home
#    kerl_home="$(dirname "$(dirname "$0")")/kerl-home"
#    mkdir -p "$kerl_home"
#    export KERL_BASE_DIR="$kerl_home"
#    export KERL_BUILD_BACKEND="git"
#    export KERL_CONFIG="$kerl_home/.kerlrc"
#}
