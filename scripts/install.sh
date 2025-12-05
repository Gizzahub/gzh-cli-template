#!/bin/bash
# install.sh - Installation helper script
# Usage: ./scripts/install.sh

set -e

BINARY_NAME="gz-__PROJECT_NAME__"
INSTALL_DIR="${GOPATH:-$HOME/go}/bin"

echo "Building ${BINARY_NAME}..."
make build

echo "Installing to ${INSTALL_DIR}..."
mkdir -p "${INSTALL_DIR}"
cp "build/${BINARY_NAME}" "${INSTALL_DIR}/"

echo "Installation complete!"
echo "Run '${BINARY_NAME} --help' to get started."
