# Architecture Overview

## Directory Structure

```
gzh-cli-__PROJECT_NAME__/
│
├── cmd/                          # CLI Commands
│   ├── AGENTS_COMMON.md          # Common AI guidelines for all modules
│   └── __PROJECT_NAME__/         # Main CLI module
│       ├── AGENTS.md             # Module-specific AI guide
│       ├── main.go               # Entry point
│       ├── root.go               # Root command + subcommands
│       └── version.go            # Version management
│
├── internal/                     # Private Packages (not importable)
│   └── core/                     # Core business logic
│       ├── core.go               # Service interfaces & implementations
│       └── core_test.go          # Unit tests
│
├── pkg/                          # Public Packages (importable by others)
│   └── api/                      # Public API interfaces
│       └── api.go                # Client & types
│
├── docs/                         # Documentation
│   ├── README.md                 # Docs index
│   └── ARCHITECTURE.md           # This file
│
├── examples/                     # Usage Examples
│   ├── README.md                 # Examples overview
│   └── config.yaml.example       # Configuration template
│
├── scripts/                      # Helper Scripts
│   ├── init-project.sh           # Project initializer (template)
│   └── install.sh                # Installation helper
│
├── tests/                        # Test Suites
│   ├── integration/              # Integration tests
│   └── e2e/                      # End-to-end tests
│
├── .github/                      # GitHub Configuration
│   ├── workflows/ci.yml          # CI pipeline
│   ├── ISSUE_TEMPLATE/           # Issue templates
│   └── PULL_REQUEST_TEMPLATE.md  # PR template
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
├── Makefile                      # Build automation
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
│                    internal/core/                    │
│           (Business logic, services)                 │
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

## Key Design Principles

### 1. Interface-Driven Design

```go
// Define interfaces in internal/
type Service interface {
    Process(input string) (string, error)
}

// Implement in separate files
type DefaultService struct{}
func (s *DefaultService) Process(input string) (string, error) { ... }
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
// Wrap errors with context
if err != nil {
    return fmt.Errorf("operation failed: %w", err)
}

// Define domain errors
var ErrNotFound = errors.New("resource not found")
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

| Layer | Test Type | Location |
|-------|-----------|----------|
| cmd/ | Unit + Integration | cmd/*_test.go |
| internal/ | Unit | internal/*/*_test.go |
| pkg/ | Unit | pkg/*/*_test.go |
| Integration | Docker-based | tests/integration/ |
| E2E | Full workflow | tests/e2e/ |

---

## Configuration

Priority (highest to lowest):
1. CLI flags
2. Environment variables
3. Config file (~/.config/gz-__PROJECT_NAME__/config.yaml)
4. Defaults

---

**Last Updated**: 2024-12-05
