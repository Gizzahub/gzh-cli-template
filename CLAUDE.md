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

---

## Development Workflow

### Before Code Modification

1. Read existing code patterns
2. Check test coverage requirements
3. Review CONTRIBUTING.md for guidelines

### Code Modification Process

```bash
# 1. Write code + tests
# 2. Quality checks (CRITICAL)
make fmt && make lint && make test
# 3. Commit with proper message format
```

---

## Essential Commands Reference

### Development Workflow

```bash
# One-time setup
make deps

# Before every commit (CRITICAL)
make quality    # runs fmt + lint + test

# Build & install
make build
make install
```

### Testing

```bash
# All tests
make test

# Unit tests only
make test-unit

# With coverage report
make test-coverage

# Benchmarks
make bench
```

### Code Quality

```bash
make fmt        # Format code
make lint       # Run linters
make quality    # All quality checks
```

---

## Project Structure

```
.
├── cmd/__PROJECT_NAME__/
│   ├── main.go          # Entry point
│   ├── root.go          # Root command
│   └── version.go       # Version management
├── internal/            # Private packages
│   └── core/            # Core business logic
├── pkg/                 # Public APIs
│   └── api/             # Exported interfaces
├── docs/                # Documentation
├── scripts/             # Helper scripts
├── tests/               # Integration/E2E tests
├── CLAUDE.md            # This file
├── go.mod               # Go module
├── Makefile             # Build automation
└── README.md            # Project documentation
```

---

## Important Rules

### Critical Requirements

- Always run `make quality` before commit
- Test coverage: 80%+ for core logic
- Korean comments allowed for documentation

### Code Style

- **Binary name**: `gz-__PROJECT_NAME__`
- **Interface-driven**: Use interfaces for testability
- **Error handling**: Structured errors with context

### Commit Format

```
{type}({scope}): {description}

{body}

Model: claude-{model}
Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types**: feat, fix, docs, refactor, test, chore
**Scope**: REQUIRED (e.g., cmd, internal, pkg)

---

## FAQ

**Q: Where to add new commands?**
A: `cmd/__PROJECT_NAME__/` - add new Command structs in root.go or separate files

**Q: Where to add internal logic?**
A: `internal/{feature}/` directory

**Q: Where to add public APIs?**
A: `pkg/{api}/` directory

---

**Last Updated**: 2024-12-05
