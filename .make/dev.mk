# .make/dev.mk - Development workflow targets
# Included by main Makefile

.PHONY: dev watch pre-commit release-dry

dev: deps fmt vet ## Setup development environment
	@echo "✅ Development environment ready"

watch: ## Watch for changes and run tests (requires entr)
	@echo "Watching for changes..."
	@if command -v entr >/dev/null 2>&1; then \
		find . -name "*.go" | entr -c make test-unit; \
	else \
		echo "⚠️  entr not installed. Install with: brew install entr (macOS) or apt install entr (Linux)"; \
	fi

pre-commit: quality ## Run pre-commit checks
	@echo "✅ Pre-commit checks passed"

release-dry: ## Dry run release (goreleaser)
	@echo "Running release dry run..."
	@if command -v goreleaser >/dev/null 2>&1; then \
		goreleaser release --snapshot --clean; \
	else \
		echo "⚠️  goreleaser not installed. Run: make install-goreleaser"; \
	fi
