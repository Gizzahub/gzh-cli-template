# First Configuration

## Configuration File

Create a configuration file at `~/.config/gz-__PROJECT_NAME__/config.yaml`:

```yaml
version: "1"
debug: false
verbose: false
log_level: info
timeout: "30s"

settings:
  # Add your custom settings here
  example_key: example_value
```

## Configuration Priority

Configuration is loaded in this order (highest priority first):

1. CLI flags (`--verbose`, `--debug`)
2. Environment variables (`GZ___PROJECT_NAME___DEBUG=true`)
3. Config file (`~/.config/gz-__PROJECT_NAME__/config.yaml`)
4. Default values

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `GZ___PROJECT_NAME___DEBUG` | Enable debug mode | `false` |
| `GZ___PROJECT_NAME___VERBOSE` | Enable verbose output | `false` |
| `GZ___PROJECT_NAME___CONFIG` | Config file path | Auto-detected |

## Verify Configuration

```bash
# Show current configuration
gz-__PROJECT_NAME__ config show

# Validate configuration
gz-__PROJECT_NAME__ config validate
```

## Next Steps

- [Architecture Overview](../20-architecture/20-overview.md)
- [Feature Documentation](../30-features/30-index.md)
