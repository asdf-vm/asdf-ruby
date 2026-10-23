#!/usr/bin/env bash

PRECOMPILED_BASE_URL="${ASDF_RUBY_PRECOMPILED_URL:-https://github.com/jdx/ruby/releases/download}"

precompiled_platform() {
  local os arch
  os="$(uname -s)"
  arch="$(uname -m)"

  case "$os" in
  Darwin)
    case "$arch" in
    arm64) echo "macos" ;;
    *) return 1 ;;
    esac
    ;;
  Linux)
    case "$arch" in
    x86_64) echo "x86_64_linux" ;;
    aarch64) echo "arm64_linux" ;;
    *) return 1 ;;
    esac
    ;;
  *) return 1 ;;
  esac
}

is_version_precompilable() {
  local version="$1"
  # Only standard MRI/CRuby versions (e.g. 4.0.1) are available as precompiled
  # binaries. Ignore prefixed variants like jruby-*, truffleruby-*, mruby-*, etc
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([-.](preview|rc|dev)[0-9]*)?$ ]]
}

precompiled_url() {
  local version="$1"
  local platform="$2"
  echo "${PRECOMPILED_BASE_URL}/${version}/ruby-${version}.${platform}.tar.gz"
}

download_precompiled() {
  local url="$1"
  local download_path="$2"

  if ! curl -fLsS -o "$download_path" "$url"; then
    return 1
  fi

  return 0
}

install_precompiled() {
  local version="$1"
  local install_path="$2"

  local platform
  if ! platform="$(precompiled_platform)"; then
    return 1
  fi

  if ! is_version_precompilable "$version"; then
    return 1
  fi

  local url
  url="$(precompiled_url "$version" "$platform")"

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local tarball="${tmp_dir}/ruby-${version}.tar.gz"

  echo "Looking for precompiled Ruby ${version} for ${platform}..."

  if ! download_precompiled "$url" "$tarball"; then
    rm -rf "$tmp_dir"
    return 1
  fi

  mkdir -p "$install_path"
  if ! tar -xzf "$tarball" -C "$install_path" --strip-components=1; then
    rm -rf "$tmp_dir" "$install_path"
    return 1
  fi

  rm -rf "$tmp_dir"
  echo "Installed precompiled Ruby ${version} successfully."
  return 0
}
