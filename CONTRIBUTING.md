# Contributing to gzh-cli-__PROJECT_NAME__

Thank you for your interest in contributing!

## Development Setup

1. Fork and clone the repository
1. Run initialization if using template:
   ```bash
   ./scripts/init-project.sh <your-project-name>
   ```
1. Install dependencies: `make deps`
1. Run tests: `make test`

## Making Changes

### Before Submitting

1. Run all quality checks:

   ```bash
   make quality
   ```

1. Ensure tests pass:

   ```bash
   make test
   ```

1. Update documentation if needed

### Commit Message Format

```
{type}({scope}): {description}

{body}
```

**Types**:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

**Scope**: Required. Examples: `cmd`, `internal`, `pkg`, `docs`

### Pull Request Process

1. Create a feature branch from `main`
1. Make your changes
1. Run `make quality`
1. Submit a PR with clear description

## Code Style

- Follow Go conventions
- Use `gofmt` and `gofumpt` for formatting
- Write tests for new features
- Keep functions small and focused

## Testing

- Unit tests: `*_test.go` files alongside source
- Integration tests: `tests/integration/`
- Aim for 80%+ coverage on core logic

## Questions?

Open an issue for discussion before major changes.
