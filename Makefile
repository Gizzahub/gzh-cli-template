# gzh-cli-__PROJECT_NAME__ Makefile
# Standard Makefile for gzh-cli-* projects

.PHONY: help build build-all test test-unit test-coverage lint fmt vet clean install deps run bench quality

# ==============================================================================
# Variables
# ==============================================================================

BINARY_NAME=gz-__PROJECT_NAME__
BUILD_DIR=build
MAIN_PKG=./cmd/__PROJECT_NAME__
VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo "dev")
GIT_COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_DATE ?= $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
LDFLAGS := -ldflags "-X main.Version=$(VERSION) -X main.GitCommit=$(GIT_COMMIT) -X main.BuildDate=$(BUILD_DATE)"

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOTEST=$(GOCMD) test
GOINSTALL=$(GOCMD) install
GOMOD=$(GOCMD) mod
GOFMT=$(GOCMD) fmt
GOVET=$(GOCMD) vet

# ==============================================================================
# Help
# ==============================================================================

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# ==============================================================================
# Build
# ==============================================================================

build: ## Build the binary
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	$(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) $(MAIN_PKG)
	@echo "Binary built: $(BUILD_DIR)/$(BINARY_NAME)"

build-all: ## Build for multiple platforms
	@echo "Building for multiple platforms..."
	@mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 $(MAIN_PKG)
	GOOS=darwin GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 $(MAIN_PKG)
	GOOS=darwin GOARCH=arm64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 $(MAIN_PKG)
	GOOS=windows GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe $(MAIN_PKG)
	@echo "Built binaries:"
	@ls -lh $(BUILD_DIR)/

# ==============================================================================
# Testing
# ==============================================================================

test: ## Run all tests
	@echo "Running tests..."
	$(GOTEST) -v -race -coverprofile=coverage.out ./...

test-unit: ## Run unit tests only
	@echo "Running unit tests..."
	$(GOTEST) -v -short ./...

test-coverage: test ## Run tests with HTML coverage report
	@echo "Generating coverage report..."
	$(GOCMD) tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report: coverage.html"

bench: ## Run benchmarks
	@echo "Running benchmarks..."
	$(GOTEST) -bench=. -benchmem ./...

# ==============================================================================
# Code Quality
# ==============================================================================

lint: ## Run linters
	@echo "Running golangci-lint..."
	@command -v golangci-lint >/dev/null 2>&1 && golangci-lint run ./... || { echo "golangci-lint not installed, running go vet only"; $(GOVET) ./...; }

fmt: ## Format code
	@echo "Formatting code..."
	$(GOFMT) ./...
	@command -v gofumpt >/dev/null 2>&1 && gofumpt -w . || echo "gofumpt not installed, using go fmt only"

vet: ## Run go vet
	@echo "Running go vet..."
	$(GOVET) ./...

quality: fmt lint test ## Run all quality checks (fmt + lint + test)
	@echo "All quality checks passed"

# ==============================================================================
# Dependencies
# ==============================================================================

deps: ## Download and tidy dependencies
	@echo "Downloading dependencies..."
	$(GOMOD) download
	$(GOMOD) tidy
	@echo "Dependencies updated"

# ==============================================================================
# Install & Run
# ==============================================================================

install: build ## Install the binary to GOPATH/bin
	@echo "Installing $(BINARY_NAME)..."
	@mkdir -p $(GOPATH)/bin
	@cp $(BUILD_DIR)/$(BINARY_NAME) $(GOPATH)/bin/$(BINARY_NAME)
	@echo "Installed to $(GOPATH)/bin/$(BINARY_NAME)"

run: ## Run the application
	@echo "Running $(BINARY_NAME)..."
	$(GOCMD) run $(MAIN_PKG)

# ==============================================================================
# Cleanup
# ==============================================================================

clean: ## Clean build artifacts
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
	@rm -f coverage.out coverage.html bench.txt
	@echo "Cleaned"

.DEFAULT_GOAL := help
