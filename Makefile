# gzh-cli-__PROJECT_NAME__ Makefile
# Modular build automation for gzh-cli-* projects

# Include modular Makefile components
include .make/vars.mk
include .make/build.mk
include .make/test.mk
include .make/quality.mk
include .make/deps.mk
include .make/tools.mk
include .make/dev.mk

.PHONY: help clean all

# ==============================================================================
# Main Targets
# ==============================================================================

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Main targets:'
	@echo '  build          Build the binary'
	@echo '  test           Run all tests'
	@echo '  quality        Run all quality checks (fmt + lint + test)'
	@echo '  install        Install binary to GOPATH/bin'
	@echo ''
	@echo 'All targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

all: deps quality build ## Full build pipeline

clean: ## Clean build artifacts
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
	@rm -f $(COVERAGE_OUT) $(COVERAGE_HTML) bench.txt
	@echo "✅ Cleaned"

.DEFAULT_GOAL := help
