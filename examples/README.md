# Examples

Usage examples for gz-__PROJECT_NAME__.

## Basic Usage

```bash
# Show help
gz-__PROJECT_NAME__ --help

# Show version
gz-__PROJECT_NAME__ version

# Example command
gz-__PROJECT_NAME__ hello
gz-__PROJECT_NAME__ hello World
```

## Configuration

Example configuration file (`config.yaml`):

```yaml
# gz-__PROJECT_NAME__ configuration
verbose: false
output: json

# Add your configuration options here
```

## Integration Examples

### Shell Script

```bash
#!/bin/bash
# Example shell script using gz-__PROJECT_NAME__

result=$(gz-__PROJECT_NAME__ hello "User")
echo "Result: $result"
```

### Go Integration

```go
package main

import (
    "github.com/gizzahub/gzh-cli-__PROJECT_NAME__/pkg/api"
)

func main() {
    client := api.NewClient("http://localhost:8080")
    // Use the client...
}
```

## More Examples

- See `examples/` directory for more detailed examples
- Check `docs/` for full documentation
