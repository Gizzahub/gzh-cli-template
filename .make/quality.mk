# .make/quality.mk - Code quality targets
# Included by main Makefile

.PHONY: lint fmt vet quality check

lint: ## Run golangci-lint
	@echo "Running golangci-lint..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run ./...; \
	else \
		echo "⚠️  golangci-lint not installed. Run: make install-tools"; \
		$(GOVET) ./...; \
	fi

fmt: ## Format code with gofmt and gofumpt
	@echo "Formatting code..."
	$(GOFMT) ./...
	@if command -v gofumpt >/dev/null 2>&1; then \
		gofumpt -w .; \
	else \
		echo "gofumpt not installed, using go fmt only"; \
	fi

vet: ## Run go vet
	@echo "Running go vet..."
	$(GOVET) ./...

quality: fmt lint test ## Run all quality checks (fmt + lint + test)
	@echo "✅ All quality checks passed"

check: vet lint ## Quick check (vet + lint, no tests)
	@echo "✅ Quick checks passed"
