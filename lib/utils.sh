#!/usr/bin/env bash

RUBY_BUILD_REPOSITORY="https://github.com/rbenv/ruby-build.git"

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
  local source_dir target_ref
  source_dir="$(ruby_build_source_dir)"

  if ! ensure_ruby_build_source "$source_dir"; then
    if [ -f "$(ruby_build_path)" ]; then
      echoerr "Warning: Could not access ruby-build source; using existing installation."
      return 0
    fi
    errorexit "Failed to clone ruby-build. Check your network connection."
  fi

  target_ref="$(resolve_ruby_build_ref "$source_dir")" ||
    errorexit "Could not determine ruby-build version."

  if needs_install "$target_ref"; then
    install_ruby_build "$source_dir" "$target_ref"
  fi
}

# Maintain a persistent clone of ruby-build. Cheap `git fetch` on each install
# keeps tag list current; set ASDF_RUBY_SKIP_RUBY_BUILD_UPDATE=1 to bypass.
ensure_ruby_build_source() {
  local source_dir="$1"

  if [ ! -d "$source_dir/.git" ]; then
    echoerr "Cloning ruby-build..."
    rm -rf "$source_dir"
    git clone "$RUBY_BUILD_REPOSITORY" "$source_dir" >/dev/null 2>&1 || return 1
    return 0
  fi

  if [ -n "${ASDF_RUBY_SKIP_RUBY_BUILD_UPDATE:-}" ]; then
    return 0
  fi

  git -C "$source_dir" fetch --tags --prune origin >/dev/null 2>&1 ||
    echoerr "Warning: Could not update ruby-build, using cached refs."
  return 0
}

# Pick the ref to check out: explicit env var > latest release tag.
resolve_ruby_build_ref() {
  local source_dir="$1"

  if [ -n "${ASDF_RUBY_BUILD_VERSION:-}" ]; then
    echo "$ASDF_RUBY_BUILD_VERSION"
    return 0
  fi

  local latest
  latest="$(git -C "$source_dir" tag --list 'v*' --sort=-v:refname | head -1)"
  if [ -n "$latest" ]; then
    echo "$latest"
    return 0
  fi
  return 1
}

needs_install() {
  local target_ref="$1" installed_version
  [ ! -f "$(ruby_build_path)" ] && return 0

  installed_version="$("$(ruby_build_path)" --version | cut -d ' ' -f2)"
  if [ "${installed_version:0:1}" != "v" ]; then
    installed_version="v$installed_version"
  fi
  [ "$installed_version" != "$target_ref" ]
}

install_ruby_build() {
  local source_dir="$1" ref="$2"
  echoerr "Installing ruby-build ${ref}..."

  local checkout_ref="$ref"
  if git -C "$source_dir" show-ref --verify --quiet "refs/remotes/origin/$ref"; then
    checkout_ref="origin/$ref"
  fi
  git -C "$source_dir" checkout --detach "$checkout_ref" >/dev/null 2>&1 ||
    errorexit "Failed to checkout ruby-build ref ${ref}."

  rm -rf "$(ruby_build_dir)"
  local install_dir
  install_dir="$(cd "$(asdf_ruby_plugin_path)" && pwd)/ruby-build"
  PREFIX="$install_dir" "$source_dir/install.sh" ||
    errorexit "Failed to install ruby-build."
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
