#!/usr/bin/env bash

echoerr() {
  echo >&2 -e "\033[0;31m$1\033[0m"
}

errorexit() {
  echoerr "$1"
  exit 1
}

ensure_ruby_build_setup() {
  ensure_ruby_build_installed
}

ensure_ruby_build_installed() {
  local current_ruby_build_version target_version

  target_version="$(get_ruby_build_version)"

  if [ ! -f "$(ruby_build_path)" ]; then
    # No ruby-build installed - we must have a version to download
    if [ -z "$target_version" ]; then
      errorexit "Could not determine ruby-build version. Check your network connection."
    fi
    download_ruby_build "$target_version"
  elif [ -n "$target_version" ]; then
    # ruby-build exists and we have a target version - check if update needed
    current_ruby_build_version="$("$(ruby_build_path)" --version | cut -d ' ' -f2)"
    # If ruby-build version does not start with 'v',
    # add 'v' to beginning of version
    # shellcheck disable=SC2086
    if [ ${current_ruby_build_version:0:1} != "v" ]; then
      current_ruby_build_version="v$current_ruby_build_version"
    fi
    if [ "$current_ruby_build_version" != "$target_version" ]; then
      # If the ruby-build directory already exists and the version does not
      # match, remove it and download the correct version
      rm -rf "$(ruby_build_dir)"
      download_ruby_build "$target_version"
    fi
  fi
  # If ruby-build exists but we couldn't get a target version, just use what's installed
}

download_ruby_build() {
  local version="$1"
  # Print to stderr so asdf doesn't assume this string is a list of versions
  echoerr "Downloading ruby-build ${version}..."
  # shellcheck disable=SC2155
  local build_dir="$(ruby_build_source_dir)"

  # Remove directory in case it still exists from last download
  rm -rf "$build_dir"

  # Clone down and checkout the correct ruby-build version
  git clone https://github.com/rbenv/ruby-build.git "$build_dir" >/dev/null 2>&1
  (
    cd "$build_dir" || exit
    git checkout "$version" >/dev/null 2>&1
  )

  # Install in the ruby-build dir (must use absolute path as install.sh changes directory)
  local install_dir
  install_dir="$(cd "$(asdf_ruby_plugin_path)" && pwd)/ruby-build"
  PREFIX="$install_dir" "$build_dir/install.sh"

  # Remove ruby-build source dir
  rm -rf "$build_dir"
}

asdf_ruby_plugin_path() {
  # shellcheck disable=SC2005
  echo "$(dirname "$(dirname "$0")")"
}
ruby_build_dir() {
  echo "$(asdf_ruby_plugin_path)/ruby-build"
}

ruby_build_source_dir() {
  echo "$(asdf_ruby_plugin_path)/ruby-build-source"
}

ruby_build_path() {
  echo "$(ruby_build_dir)/bin/ruby-build"
}

ruby_build_version_cache_path() {
  echo "$(asdf_ruby_plugin_path)/.ruby-build-version-cache"
}

# Get file modification time in seconds since epoch (cross-platform)
get_file_mtime() {
  local file="$1"
  # Try GNU stat first (Linux), then BSD stat (macOS)
  stat -c %Y "$file" 2>/dev/null || stat -f %m "$file" 2>/dev/null
}

# Fetch the latest ruby-build version tag from GitHub
fetch_latest_ruby_build_version() {
  git ls-remote --tags --sort=-version:refname https://github.com/rbenv/ruby-build.git 2>/dev/null |
    grep -oE 'refs/tags/v[0-9]+$' |
    head -1 |
    sed 's|refs/tags/||'
}

# Get the ruby-build version to use, with caching
# Priority: ASDF_RUBY_BUILD_VERSION env var > cached latest > fetched latest > installed version
get_ruby_build_version() {
  # If user explicitly set a version, use that
  if [ -n "${ASDF_RUBY_BUILD_VERSION:-}" ]; then
    echo "$ASDF_RUBY_BUILD_VERSION"
    return 0
  fi

  local cache_file
  cache_file="$(ruby_build_version_cache_path)"

  # Check cache first (unless ASDF_RUBY_BUILD_CACHE_CLEAR is set)
  if [ -z "${ASDF_RUBY_BUILD_CACHE_CLEAR:-}" ] && [ -f "$cache_file" ]; then
    local cache_mtime current_time age
    cache_mtime="$(get_file_mtime "$cache_file")"
    current_time="$(date +%s)"
    age=$((current_time - cache_mtime))

    # Cache for 24 hours
    if [ "$age" -lt 86400 ]; then
      cat "$cache_file"
      return 0
    fi
  fi

  # Fetch latest version from GitHub
  local latest_version
  latest_version="$(fetch_latest_ruby_build_version)"

  if [ -n "$latest_version" ]; then
    echo "$latest_version" >"$cache_file"
    echo "$latest_version"
    return 0
  fi

  # Fallback: if ruby-build is already installed, use its version
  # (if we can't reach GitHub, we likely can't download a new version anyway)
  if [ -f "$(ruby_build_path)" ]; then
    local installed_version
    installed_version="$("$(ruby_build_path)" --version | cut -d ' ' -f2)"
    if [ "${installed_version:0:1}" != "v" ]; then
      installed_version="v$installed_version"
    fi
    echoerr "Warning: Could not fetch latest ruby-build version, using installed version ${installed_version}"
    echo "$installed_version"
    return 0
  fi

  # No version available
  return 1
}
