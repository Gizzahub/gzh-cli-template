# Features

## Feature Index

| Feature | Description | Status |
|---------|-------------|--------|
| [Core Feature](31-core-feature.md) | Main functionality | ✅ Stable |
| Version Info | Display version | ✅ Stable |

## Adding New Features

1. Create command in `cmd/__PROJECT_NAME__/`
2. Implement logic in `internal/`
3. Add tests
4. Document in `docs/30-features/`

## Feature Template

```go
var myCmd = &cobra.Command{
    Use:   "mycommand",
    Short: "Brief description",
    Long:  `Detailed description...`,
    RunE: func(cmd *cobra.Command, args []string) error {
        // Implementation
        return nil
    },
}
```

## See Also

- [Architecture](../20-architecture/20-overview.md)
- [Configuration](../40-configuration/40-overview.md)
