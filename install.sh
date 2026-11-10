#!/bin/sh
# Legion installer: downloads the latest release for this OS/CPU.
#   curl -fsSL https://bagsiz.github.io/legion-site/install.sh | sh
# Options (env): LEGION_VERSION=v0.1.0  LEGION_BIN_DIR=$HOME/.local/bin
set -eu
REPO="bagsiz/legion-site"
BIN_DIR="${LEGION_BIN_DIR:-$HOME/.local/bin}"

os=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$os" in darwin|linux) ;; *) echo "legion: unsupported OS: $os" >&2; exit 1;; esac
arch=$(uname -m)
case "$arch" in x86_64|amd64) arch=amd64;; arm64|aarch64) arch=arm64;; *) echo "legion: unsupported CPU: $arch" >&2; exit 1;; esac

version="${LEGION_VERSION:-}"
if [ -z "$version" ]; then
  version=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1)
fi
[ -n "$version" ] || { echo "legion: could not determine the latest version" >&2; exit 1; }

name="legion_${version#v}_${os}_${arch}.tar.gz"
base="https://github.com/$REPO/releases/download/$version"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Downloading Legion $version ($os/$arch)…"
curl -fsSL -o "$tmp/$name" "$base/$name"
curl -fsSL -o "$tmp/checksums.txt" "$base/checksums.txt"
expected=$(grep " $name\$" "$tmp/checksums.txt" | cut -d' ' -f1)
if command -v sha256sum >/dev/null 2>&1; then actual=$(sha256sum "$tmp/$name" | cut -d' ' -f1)
else actual=$(shasum -a 256 "$tmp/$name" | cut -d' ' -f1); fi
[ "$expected" = "$actual" ] || { echo "legion: checksum mismatch for $name" >&2; exit 1; }

tar -xzf "$tmp/$name" -C "$tmp"
mkdir -p "$BIN_DIR"
install -m 0755 "$tmp/legion" "$BIN_DIR/legion"
echo "Installed $BIN_DIR/legion ($("$BIN_DIR/legion" --version))"
case ":$PATH:" in *":$BIN_DIR:"*) ;; *) echo "Add $BIN_DIR to your PATH to run legion.";; esac
echo "Next: cd into a git repo, run 'legion init', then 'legion'."
