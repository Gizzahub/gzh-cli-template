#!/bin/bash
# init-project.sh - Initialize a new project from gzh-cli-template
#
# Usage: ./scripts/init-project.sh <project-name>
#
# Example:
#   ./scripts/init-project.sh mytool
#   # Creates: gzh-cli-mytool, binary: gz-mytool

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Validate arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <project-name>"
    echo ""
    echo "Example:"
    echo "  $0 mytool"
    echo "  # Creates project: gzh-cli-mytool"
    echo "  # Binary name: gz-mytool"
    echo "  # Module: github.com/gizzahub/gzh-cli-mytool"
    exit 1
fi

PROJECT_NAME="$1"

# Validate project name (alphanumeric and hyphens only)
if [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    error "Project name must start with lowercase letter and contain only lowercase letters, numbers, and hyphens"
fi

# Derived names
FULL_PROJECT_NAME="gzh-cli-${PROJECT_NAME}"
BINARY_NAME="gz-${PROJECT_NAME}"
MODULE_PATH="github.com/gizzahub/${FULL_PROJECT_NAME}"

info "Initializing project: ${FULL_PROJECT_NAME}"
info "Binary name: ${BINARY_NAME}"
info "Module path: ${MODULE_PATH}"
echo ""

# Check if placeholder directory exists
if [ ! -d "cmd/__PROJECT_NAME__" ]; then
    error "Template directory cmd/__PROJECT_NAME__ not found. Are you in the template root?"
fi

# Replace placeholders in all files
info "Replacing placeholders in files..."

# Find and replace in all text files
find . -type f \( -name "*.go" -o -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "Makefile" -o -name "*.mod" \) \
    -not -path "./.git/*" \
    -exec sed -i "s/__PROJECT_NAME__/${PROJECT_NAME}/g" {} \;

info "Renaming directories..."

# Rename cmd directory
if [ -d "cmd/__PROJECT_NAME__" ]; then
    mv "cmd/__PROJECT_NAME__" "cmd/${PROJECT_NAME}"
    info "Renamed cmd/__PROJECT_NAME__ -> cmd/${PROJECT_NAME}"
fi

# Update go.mod module path
info "Updating go.mod..."
sed -i "s|github.com/gizzahub/gzh-cli-${PROJECT_NAME}|${MODULE_PATH}|g" go.mod

# Remove this init script (optional - keep for reference)
# rm -f scripts/init-project.sh

# Update scripts
info "Updating scripts..."
if [ -f "scripts/install.sh" ]; then
    sed -i "s/gz-__PROJECT_NAME__/${BINARY_NAME}/g" scripts/install.sh
fi

# Clean up old init-template.sh if exists
rm -f scripts/init-template.sh

echo ""
info "Project initialized successfully!"
echo ""
echo "Next steps:"
echo "  1. make deps      # Download dependencies"
echo "  2. make build     # Build the binary"
echo "  3. make test      # Run tests"
echo "  4. ./build/${BINARY_NAME} --help"
echo ""
echo "To commit:"
echo "  git add ."
echo "  git commit -m 'feat(init): initialize ${FULL_PROJECT_NAME} from template'"
echo ""
info "Happy coding!"
