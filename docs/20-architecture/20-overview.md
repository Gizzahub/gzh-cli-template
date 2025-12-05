# Architecture Overview

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
│                    internal/                         │
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

## Directory Structure

```
gzh-cli-__PROJECT_NAME__/
├── cmd/__PROJECT_NAME__/     # CLI commands (entry point)
├── internal/                  # Private packages
│   ├── config/               # Configuration management
│   ├── core/                 # Core business logic
│   ├── errors/               # Custom error types
│   ├── logger/               # Logging utilities
│   └── testutil/             # Test helpers
├── pkg/api/                  # Public APIs
├── docs/                     # Documentation
├── examples/                 # Usage examples
├── scripts/                  # Helper scripts
└── tests/                    # Integration/E2E tests
```

## Design Principles

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
// Use custom error types with context
if err != nil {
    return errors.WrapWithMessage(err, "operation failed")
}
```

## Data Flow

```
User Input → CLI (cmd/) → Service (internal/) → Output
                ↓
         pkg/api/ (if external integration needed)
```

## See Also

- [21-directory-structure.md](21-directory-structure.md) - Detailed directory guide
- [22-coding-standards.md](22-coding-standards.md) - Coding conventions
