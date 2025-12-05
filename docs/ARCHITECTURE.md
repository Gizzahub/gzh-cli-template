# Architecture Overview

## Directory Structure

```
gzh-cli-__PROJECT_NAME__/
│
├── .github/                      # GitHub Configuration
│   ├── workflows/
│   │   ├── ci.yml               # CI pipeline (multi-OS, lint, security)
│   │   └── release.yml          # Release automation
│   ├── dependabot.yml           # Dependency updates
│   ├── ISSUE_TEMPLATE/          # Issue templates
│   └── PULL_REQUEST_TEMPLATE.md # PR template
│
├── .make/                        # Modular Makefile
│   ├── vars.mk                  # Common variables
│   ├── build.mk                 # Build targets
│   ├── test.mk                  # Testing targets
│   ├── quality.mk               # Code quality
│   ├── deps.mk                  # Dependencies
│   ├── tools.mk                 # Tool installation
│   └── dev.mk                   # Development workflow
│
├── cmd/                          # CLI Commands
│   ├── AGENTS_COMMON.md         # Common AI guidelines
│   └── __PROJECT_NAME__/        # Main CLI module
│       ├── AGENTS.md            # Module-specific AI guide
│       ├── main.go              # Entry point
│       ├── root.go              # Root command + subcommands
│       └── version.go           # Version management
│
├── internal/                     # Private Packages
│   ├── config/                  # Configuration management
│   │   ├── config.go            # Config loader & types
│   │   └── config_test.go       # Tests
│   ├── core/                    # Core business logic
│   │   ├── core.go              # Service interfaces
│   │   └── core_test.go         # Tests
│   ├── errors/                  # Custom error types
│   │   ├── errors.go            # Error definitions
│   │   └── errors_test.go       # Tests
│   ├── logger/                  # Logging utilities
│   │   ├── logger.go            # Structured logger
│   │   └── logger_test.go       # Tests
│   └── testutil/                # Test utilities
│       ├── testutil.go          # Common test helpers
│       └── builders/            # Fluent test builders
│           ├── builder.go       # Builder patterns
│           └── builder_test.go  # Tests
│
├── pkg/                          # Public Packages
│   └── api/                     # Public API interfaces
│       └── api.go               # Client & types
│
├── docs/                         # Documentation (hierarchical)
│   ├── 00-overview/             # Overview & introduction
│   ├── 10-getting-started/      # Installation, quick start
│   ├── 20-architecture/         # Architecture docs
│   ├── 30-features/             # Feature documentation
│   ├── 40-configuration/        # Configuration reference
│   ├── README.md                # Docs index
│   └── ARCHITECTURE.md          # This file
│
├── examples/                     # Usage Examples
│   ├── README.md                # Examples overview
│   └── config.yaml.example      # Configuration template
│
├── scripts/                      # Helper Scripts
│   ├── init-project.sh          # Template initializer
│   └── install.sh               # Installation helper
│
├── tests/                        # Test Suites
│   ├── integration/             # Integration tests
│   └── e2e/                     # End-to-end tests
│
├── .claudeignore                 # Files AI should not modify
├── .gitignore                    # Git ignore patterns
├── .golangci.yml                 # Linter configuration (v2)
├── .goreleaser.yml               # Release automation
├── .pre-commit-config.yaml       # Pre-commit hooks
│
├── CLAUDE.md                     # AI Development Guide
├── CONTRIBUTING.md               # Contribution guidelines
├── LICENSE                       # MIT License
├── Makefile                      # Build automation (modular)
├── README.md                     # Project overview
└── go.mod                        # Go module definition
```

---

## Layer Architecture

```
┌─────────────────────────────────────────────────────┐
│                      CLI Layer                       │
│                   cmd/__PROJECT_NAME__/              │
│              (Cobra commands, flags, I/O)            │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│                   Internal Layer                     │
│                      internal/                       │
│        ┌─────────────────────────────────┐          │
│        │ config/ │ core/ │ errors/ │ logger/ │      │
│        └─────────────────────────────────┘          │
│           (Business logic, utilities)                │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│                   Public API Layer                   │
│                      pkg/api/                        │
│          (Reusable interfaces, clients)              │
└─────────────────────────────────────────────────────┘
```

---

## Internal Packages

| Package | Purpose | Key Types |
|---------|---------|-----------|
| `config` | Configuration management | `Config`, `Load()`, `Save()` |
| `core` | Core business logic | `Service` interface |
| `errors` | Custom error types | `ErrNotFound`, `Wrap()` |
| `logger` | Structured logging | `Logger` interface, `SimpleLogger` |
| `testutil` | Test utilities | `TempFile()`, `AssertEqual()` |
| `testutil/builders` | Fluent test fixtures | `ConfigBuilder`, `CommandBuilder` |

---

## Key Design Principles

### 1. Interface-Driven Design

```go
// Define interfaces in internal/
type Service interface {
    Process(input string) (string, error)
}
```

### 2. Dependency Injection

```go
// Constructor injection, no DI containers
func NewService(config Config, logger Logger) *Service {
    return &Service{config: config, logger: logger}
}
```

### 3. Error Handling

```go
// Use custom error types
import "github.com/gizzahub/gzh-cli-__PROJECT_NAME__/internal/errors"

if err != nil {
    return errors.WrapWithMessage(err, "operation failed")
}
```

### 4. Structured Logging

```go
import "github.com/gizzahub/gzh-cli-__PROJECT_NAME__/internal/logger"

log := logger.New("mycomponent")
log.Info("operation complete", "count", 42)
```

---

## Data Flow

```
User Input → CLI (cmd/) → Service (internal/) → Output
                ↓
         pkg/api/ (if external integration needed)
```

---

## Testing Strategy

| Layer | Test Type | Location | Coverage Target |
|-------|-----------|----------|-----------------|
| cmd/ | Unit + Integration | cmd/*_test.go | 70%+ |
| internal/ | Unit | internal/*/*_test.go | 80%+ |
| pkg/ | Unit | pkg/*/*_test.go | 85%+ |
| Integration | Docker-based | tests/integration/ | - |
| E2E | Full workflow | tests/e2e/ | - |

### Test Utilities

```go
import "github.com/gizzahub/gzh-cli-__PROJECT_NAME__/internal/testutil"

func TestSomething(t *testing.T) {
    // Create temp file
    path := testutil.TempFile(t, "test.yaml", "key: value")

    // Assert helpers
    testutil.AssertNoError(t, err)
    testutil.AssertEqual(t, got, want)
}
```

---

## Configuration

Priority (highest to lowest):
1. CLI flags (`--verbose`, `--debug`)
2. Environment variables (`GZ___PROJECT_NAME___DEBUG=true`)
3. Config file (`~/.config/gz-__PROJECT_NAME__/config.yaml`)
4. Defaults

---

## Build Automation

```bash
# Modular Makefile structure
make help           # Show all targets
make build          # Build binary
make test           # Run tests
make quality        # fmt + lint + test
make install-tools  # Install dev tools
make release-dry    # Test release
```

---

**Last Updated**: 2024-12-05
