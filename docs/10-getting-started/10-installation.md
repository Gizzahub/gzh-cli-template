# Installation

## Prerequisites

- Go 1.24 or higher
- Git (for source installation)

## Installation Methods

### Using Go Install

```bash
go install github.com/gizzahub/gzh-cli-__PROJECT_NAME__/cmd/__PROJECT_NAME__@latest
```

### From Source

```bash
git clone https://github.com/gizzahub/gzh-cli-__PROJECT_NAME__.git
cd gzh-cli-__PROJECT_NAME__
make install
```

### Using Homebrew (macOS/Linux)

```bash
brew install gizzahub/tap/gz-__PROJECT_NAME__
```

### Binary Download

Download pre-built binaries from [GitHub Releases](https://github.com/gizzahub/gzh-cli-__PROJECT_NAME__/releases).

## Verify Installation

```bash
gz-__PROJECT_NAME__ --version
```

## Next Steps

- [Quick Start](11-quick-start.md)
- [First Configuration](12-first-configuration.md)
