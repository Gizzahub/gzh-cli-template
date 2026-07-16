#!/bin/bash
# 스크립트명: init-project.sh
# 용도: gzh-cli-template에서 새 프로젝트를 초기화 (placeholder 치환)
# 사용법: ./scripts/init-project.sh <project-name>
#
# Example:
#   ./scripts/init-project.sh mytool
#   # Creates: gzh-cli-mytool, binary: gz-mytool

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Portable in-place sed (GNU vs BSD). Never use bare `sed -i` — BSD treats the
# next argument as a mandatory backup suffix and leaves the repo half-mutated.
sed_inplace() {
	local expr=$1
	shift
	if sed --version >/dev/null 2>&1; then
		# GNU sed
		sed -i -e "${expr}" "$@"
	else
		# BSD sed (macOS)
		sed -i '' -e "${expr}" "$@"
	fi
}

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

# Preflight: required tools and template layout (fail before mutating anything)
command -v sed >/dev/null 2>&1 || error "sed is required"
command -v find >/dev/null 2>&1 || error "find is required"
if [ ! -d "cmd/__PROJECT_NAME__" ]; then
	error "Template directory cmd/__PROJECT_NAME__ not found. Are you in the template root?"
fi
if [ ! -f "go.mod" ]; then
	error "go.mod not found. Are you in the template root?"
fi

# Derived names
FULL_PROJECT_NAME="gzh-cli-${PROJECT_NAME}"
BINARY_NAME="gz-${PROJECT_NAME}"
MODULE_PATH="github.com/gizzahub/${FULL_PROJECT_NAME}"

info "Initializing project: ${FULL_PROJECT_NAME}"
info "Binary name: ${BINARY_NAME}"
info "Module path: ${MODULE_PATH}"
echo ""

# Smoke-test sed_inplace on a temp file before touching the tree
_tmp=$(mktemp)
echo "__PROJECT_NAME__" >"${_tmp}"
sed_inplace "s/__PROJECT_NAME__/probe/g" "${_tmp}"
grep -q probe "${_tmp}" || {
	rm -f "${_tmp}"
	error "sed_inplace smoke test failed (GNU/BSD sed incompatibility)"
}
rm -f "${_tmp}"

info "Replacing placeholders in files..."
_count=0
while IFS= read -r -d '' f; do
	sed_inplace "s/__PROJECT_NAME__/${PROJECT_NAME}/g" "${f}"
	_count=$((_count + 1))
done < <(
	find . -type f \( \
		-name "*.go" -o -name "*.md" -o -name "*.yml" -o -name "*.yaml" \
		-o -name "*.sh" -o -name "Makefile" -o -name "*.mod" \
	\) -not -path "./.git/*" -not -path "./scripts/init-project.sh" -print0
)

if [ "${_count}" -eq 0 ]; then
	error "No template files found to rewrite"
fi
info "Rewrote ${_count} files"

info "Renaming directories..."

# Rename cmd directory (after content rewrite so failed sed never leaves a renamed tree)
if [ -d "cmd/__PROJECT_NAME__" ]; then
	mv "cmd/__PROJECT_NAME__" "cmd/${PROJECT_NAME}"
	info "Renamed cmd/__PROJECT_NAME__ -> cmd/${PROJECT_NAME}"
elif [ -d "cmd/${PROJECT_NAME}" ]; then
	info "cmd/${PROJECT_NAME} already present"
else
	error "Neither cmd/__PROJECT_NAME__ nor cmd/${PROJECT_NAME} found after rewrite"
fi

# Update go.mod module path
info "Updating go.mod..."
# After placeholder rewrite, module line may already be gzh-cli-<name>; force final module path
sed_inplace "s|^module .*|module ${MODULE_PATH}|g" go.mod

# Update scripts
info "Updating scripts..."
if [ -f "scripts/install.sh" ]; then
	# BINARY may still contain placeholder or already-substituted name
	sed_inplace "s/gz-__PROJECT_NAME__/${BINARY_NAME}/g" scripts/install.sh
	sed_inplace "s/gz-${PROJECT_NAME}/${BINARY_NAME}/g" scripts/install.sh
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
