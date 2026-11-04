#!/bin/sh
set -e

# zplflow CLI standalone installer
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/zplflow/zplflow-cli/main/scripts/install-cli.sh | bash

REPO="zplflow/zplflow-cli"
BIN_NAME="zplflow"

echo "==> Detecting OS and architecture..."

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  linux*)  TARGET_OS="linux" ;;
  darwin*) TARGET_OS="darwin" ;;
  msys*|mingw*|cygwin*) TARGET_OS="windows" ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 1
    ;;
esac

case "$ARCH" in
  x86_64|amd64) TARGET_ARCH="amd64" ;;
  arm64|aarch64) TARGET_ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

echo "    Platform detected: ${TARGET_OS}_${TARGET_ARCH}"

# Determine target install directory
if [ "$(id -u)" -eq 0 ]; then
  DEST_DIR="/usr/local/bin"
elif [ -d "$HOME/.local/bin" ] && echo "$PATH" | grep -q "$HOME/.local/bin"; then
  DEST_DIR="$HOME/.local/bin"
else
  DEST_DIR="/usr/local/bin"
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

echo "==> Finding latest CLI release..."
LATEST_TAG="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases" | grep -o '"tag_name": *"cli/v[^"]*"' | head -n 1 | sed 's/"tag_name": *"//;s/"//')"

if [ -z "$LATEST_TAG" ]; then
  # Fallback to general release if tag format differs
  LATEST_TAG="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep -o '"tag_name": *"[^"]*"' | head -n 1 | sed 's/"tag_name": *"//;s/"//')"
fi

if [ -z "$LATEST_TAG" ]; then
  echo "Error: Could not determine latest release tag from GitHub." >&2
  exit 1
fi

echo "    Latest version found: ${LATEST_TAG}"

EXT="tar.gz"
if [ "$TARGET_OS" = "windows" ]; then
  EXT="zip"
fi

if [ "$TARGET_OS" = "darwin" ]; then
  ASSET_NAME="zplflow_darwin_all.${EXT}"
else
  ASSET_NAME="zplflow_${TARGET_OS}_${TARGET_ARCH}.${EXT}"
fi
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_TAG}/${ASSET_NAME}"

echo "==> Downloading ${ASSET_NAME}..."
curl -fsSL -o "${TMP_DIR}/${ASSET_NAME}" "$DOWNLOAD_URL"

echo "==> Extracting binary..."
cd "$TMP_DIR"
if [ "$EXT" = "zip" ]; then
  unzip -q "$ASSET_NAME"
else
  tar -xzf "$ASSET_NAME"
fi

echo "==> Installing ${BIN_NAME} into ${DEST_DIR}..."
if [ -w "$DEST_DIR" ]; then
  mv "${TMP_DIR}/${BIN_NAME}" "${DEST_DIR}/${BIN_NAME}"
  chmod +x "${DEST_DIR}/${BIN_NAME}"
else
  echo "    Permission required for ${DEST_DIR}. Requesting sudo..."
  sudo mv "${TMP_DIR}/${BIN_NAME}" "${DEST_DIR}/${BIN_NAME}"
  sudo chmod +x "${DEST_DIR}/${BIN_NAME}"
fi

echo "==> Verification:"
"${DEST_DIR}/${BIN_NAME}" version

echo ""
echo "Successfully installed zplflow to ${DEST_DIR}/${BIN_NAME}"
echo "Run 'zplflow --help' to get started."
