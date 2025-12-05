# CLAUDE.md

This file provides LLM-optimized guidance for Claude Code when working with this repository.

---

## Project Context

**Binary**: `gz-__PROJECT_NAME__`
**Module**: `github.com/gizzahub/gzh-cli-__PROJECT_NAME__`
**Go Version**: 1.24+
**Architecture**: Standard CLI (Cobra-based)

### Core Principles

- **Interface-driven design**: Use Go interfaces for abstraction
- **Direct constructors**: No DI containers, simple factory pattern
- **Modular commands**: Each command is self-contained under `cmd/`
- **Structured errors**: Use `internal/errors` for custom error types
- **Structured logging**: Use `internal/logger` for consistent logging

---

## Module-Specific Guides (AGENTS.md)

**Read these before modifying code:**

| Guide | Location | Purpose |
|-------|----------|---------|
| Common Rules | `cmd/AGENTS_COMMON.md` | Project-wide conventions |
| CLI Module | `cmd/__PROJECT_NAME__/AGENTS.md` | CLI-specific rules |

---

## Internal Packages

| Package | Purpose | Usage |
|---------|---------|-------|
| `internal/config` | Configuration management | `config.Load()`, `config.Save()` |
| `internal/core` | Core business logic | Service interfaces |
| `internal/errors` | Custom error types | `errors.Wrap()`, `errors.ErrNotFound` |
| `internal/logger` | Structured logging | `logger.New()`, `logger.Info()` |
| `internal/testutil` | Test utilities | `testutil.TempFile()`, `testutil.AssertEqual()` |
| `internal/testutil/builders` | Test fixtures | `builders.NewConfigBuilder()` |

---

## Development Workflow

### Before Code Modification

1. **Read AGENTS.md** for the module you're modifying
2. Check existing code patterns in `internal/`
3. Review CONTRIBUTING.md for guidelines

### Code Modification Process

```bash
# 1. Write code + tests
# 2. Quality checks (CRITICAL)
make quality    # runs fmt + lint + test
# 3. Commit with proper message format
```

---

## Essential Commands Reference

### Development Workflow

```bash
# One-time setup
make deps
make install-tools  # Install golangci-lint, gofumpt

# Before every commit (CRITICAL)
make quality    # runs fmt + lint + test

# Build & install
make build
make install

# Development helpers
make watch         # Watch for changes (requires entr)
make release-dry   # Test goreleaser
```

### Testing

```bash
make test           # All tests with race detection
make test-unit      # Unit tests only
make test-coverage  # Generate HTML report
make bench          # Run benchmarks
```

### Code Quality

```bash
make fmt        # Format code
make lint       # Run golangci-lint
make vet        # Run go vet
make check      # Quick check (vet + lint)
make quality    # Full quality check
```

---

## Project Structure

```
.
├── .make/                       # Modular Makefile
│   ├── vars.mk                 # Variables
│   ├── build.mk                # Build targets
│   ├── test.mk                 # Test targets
│   ├── quality.mk              # Quality targets
│   ├── deps.mk                 # Dependency management
│   ├── tools.mk                # Tool installation
│   └── dev.mk                  # Development workflow
├── cmd/
│   ├── AGENTS_COMMON.md        # Common AI guidelines
│   └── __PROJECT_NAME__/
│       ├── AGENTS.md           # Module-specific guide
│       ├── main.go             # Entry point
│       ├── root.go             # Root command
│       └── version.go          # Version management
├── internal/                    # Private packages
│   ├── config/                 # Configuration
│   ├── core/                   # Core business logic
│   ├── errors/                 # Custom error types
│   ├── logger/                 # Structured logging
│   └── testutil/               # Test utilities
│       └── builders/           # Test fixture builders
├── pkg/                         # Public APIs
│   └── api/                    # Exported interfaces
├── docs/
│   ├── 00-overview/            # Overview docs
│   ├── 10-getting-started/     # Getting started
│   ├── 20-architecture/        # Architecture
│   ├── 30-features/            # Features
│   ├── 40-configuration/       # Configuration
│   └── ARCHITECTURE.md         # Full structure
├── examples/                    # Usage examples
├── scripts/                     # Helper scripts
├── tests/                       # Integration/E2E tests
├── .github/
│   ├── workflows/ci.yml        # CI (multi-OS, security)
│   ├── workflows/release.yml   # Release automation
│   └── dependabot.yml          # Dependency updates
├── .claudeignore               # AI-excluded files
├── .golangci.yml               # Linter config (v2)
├── .goreleaser.yml             # Release automation
├── .pre-commit-config.yaml     # Pre-commit hooks
├── CLAUDE.md                   # This file
├── go.mod                      # Go module
├── Makefile                    # Build automation (modular)
└── README.md                   # Project documentation
```

---

## Important Rules

### Critical Requirements

- **Read AGENTS.md** before modifying any module
- Always run `make quality` before commit
- Test coverage: 80%+ for core logic
- Korean comments allowed for documentation

### Code Style

- **Binary name**: `gz-__PROJECT_NAME__`
- **Interface-driven**: Use interfaces for testability
- **Error handling**: Use `internal/errors` package
- **Logging**: Use `internal/logger` package

### Commit Format

```
{type}({scope}): {description}

{body}

Model: claude-{model}
Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types**: feat, fix, docs, refactor, test, chore
**Scope**: REQUIRED (e.g., cmd, internal, pkg, make)

---

## FAQ

**Q: Where to add new commands?**
A: `cmd/__PROJECT_NAME__/` - see `cmd/__PROJECT_NAME__/AGENTS.md`

**Q: Where to add internal logic?**
A: `internal/{feature}/` directory

**Q: Where to add public APIs?**
A: `pkg/{api}/` directory

**Q: How to handle errors?**
A: Use `internal/errors` - `errors.Wrap()`, `errors.WrapWithMessage()`

**Q: How to add logging?**
A: Use `internal/logger` - `log := logger.New("component")`

**Q: What files should AI not modify?**
A: See `.claudeignore`

---

**Last Updated**: 2024-12-05
