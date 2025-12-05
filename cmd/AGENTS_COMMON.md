# AGENTS_COMMON.md - Common Guidelines for All Modules

This document defines common rules that apply to all modules in gzh-cli-__PROJECT_NAME__.

---

## Code Standards

### Naming Conventions

- **Functions**: camelCase (exported: PascalCase)
- **Variables**: camelCase
- **Constants**: PascalCase or SCREAMING_SNAKE_CASE
- **Files**: snake_case.go
- **Packages**: lowercase, single word preferred

### Error Handling

```go
// Always wrap errors with context
if err != nil {
    return fmt.Errorf("failed to do X: %w", err)
}

// Use structured errors for recoverable errors
var ErrNotFound = errors.New("resource not found")
```

### Testing

- Unit tests: `*_test.go` alongside source
- Test function naming: `Test<Function>_<Scenario>`
- Use table-driven tests for multiple cases
- Aim for 80%+ coverage on core logic

---

## Development Workflow

### Before Committing

```bash
# CRITICAL: Always run before commit
make quality  # fmt + lint + test
```

### Commit Message Format

```
{type}({scope}): {description}

{body}

Model: claude-{model}
Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types**: feat, fix, docs, refactor, test, chore
**Scope**: Module name (e.g., cmd, internal, pkg)

---

## Module Structure

Each module should follow this structure:

```
cmd/{module}/
├── AGENTS.md        # Module-specific rules (this file pattern)
├── main.go          # Entry point (if standalone)
├── root.go          # Root command
├── {command}.go     # Subcommands
└── {command}_test.go
```

---

## Forbidden Patterns

- ❌ Global mutable state
- ❌ Hardcoded secrets or credentials
- ❌ Ignoring errors without explicit reason
- ❌ `panic()` in library code (only in main)
- ❌ Circular imports

## Recommended Patterns

- ✅ Interface-driven design
- ✅ Dependency injection via constructors
- ✅ Context propagation for cancellation
- ✅ Structured logging
- ✅ Graceful shutdown handling

---

## Documentation Requirements

- All exported functions must have GoDoc comments
- Complex logic should have inline comments explaining "why"
- README.md for each major package

---

**Last Updated**: 2024-12-05
