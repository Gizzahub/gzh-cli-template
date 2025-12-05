# gzh-cli-template

Standard template for building gzh-cli-* CLI tools in Go.

## Using This Template

### Option 1: GitHub "Use this template" (Recommended)

1. Click **"Use this template"** button on GitHub
2. Create your new repository (e.g., `gzh-cli-mytool`)
3. Clone your new repository
4. Run the initialization script:

```bash
./scripts/init-project.sh mytool
```

### Option 2: Manual Clone

```bash
# Clone template
git clone https://github.com/gizzahub/gzh-cli-template.git gzh-cli-mytool
cd gzh-cli-mytool

# Remove template git history
rm -rf .git

# Initialize your project
./scripts/init-project.sh mytool

# Start fresh git
git init
git add .
git commit -m "Initial commit from gzh-cli-template"
```

## After Initialization

```bash
# Download dependencies
make deps

# Build
make build

# Test
make test

# Run
./build/gz-mytool --help
```

## Template Structure

```
.
├── cmd/__PROJECT_NAME__/    # CLI entry point
│   ├── main.go              # Main function
│   ├── root.go              # Root command (Cobra)
│   └── version.go           # Version management
├── internal/core/           # Private business logic
├── pkg/api/                 # Public APIs
├── docs/                    # Documentation
├── scripts/
│   └── init-project.sh      # Project initializer
├── tests/                   # Integration tests
├── .github/workflows/       # CI configuration
├── .golangci.yml            # Linter configuration
├── CLAUDE.md                # AI development guide
├── Makefile                 # Build automation
└── README.md                # This file
```

## Placeholders

The template uses `__PROJECT_NAME__` as placeholder. The init script replaces:

| Placeholder | Example |
|-------------|---------|
| `__PROJECT_NAME__` | `mytool` |
| `gzh-cli-__PROJECT_NAME__` | `gzh-cli-mytool` |
| `gz-__PROJECT_NAME__` | `gz-mytool` |

## Features

- Cobra CLI framework
- Makefile with standard targets
- golangci-lint v2 configuration
- GitHub Actions CI
- CLAUDE.md for AI-assisted development
- Test structure with examples

## Available Make Targets

```bash
make help       # Show all targets
make build      # Build binary
make test       # Run tests
make lint       # Run linters
make quality    # Run all checks (fmt + lint + test)
make clean      # Clean artifacts
```

## License

MIT License - see [LICENSE](LICENSE)
