# Configuration Overview

## Configuration File Format

gz-__PROJECT_NAME__ uses YAML configuration files.

### Default Location

```
~/.config/gz-__PROJECT_NAME__/config.yaml
```

### Full Configuration Reference

```yaml
# Configuration version
version: "1"

# Debug mode - enables detailed logging
debug: false

# Verbose output
verbose: false

# Log level: debug, info, warn, error
log_level: info

# Operation timeout (e.g., "30s", "5m", "1h")
timeout: "30s"

# Custom application settings
settings:
  key1: value1
  key2: value2
```

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | "1" | Config file version |
| `debug` | bool | false | Enable debug mode |
| `verbose` | bool | false | Enable verbose output |
| `log_level` | string | "info" | Logging level |
| `timeout` | string | "30s" | Operation timeout |
| `settings` | map | {} | Custom settings |

## Environment Variables

All configuration options can be set via environment variables:

```bash
export GZ___PROJECT_NAME___DEBUG=true
export GZ___PROJECT_NAME___VERBOSE=true
export GZ___PROJECT_NAME___LOG_LEVEL=debug
```

## CLI Flags

CLI flags override all other configuration:

```bash
gz-__PROJECT_NAME__ --debug --verbose --log-level=debug
```

## Configuration Priority

1. CLI flags (highest)
2. Environment variables
3. Config file
4. Defaults (lowest)

## See Also

- [Getting Started](../10-getting-started/12-first-configuration.md)
- [Examples](../../examples/)
