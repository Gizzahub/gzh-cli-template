# AGENTS.md - __PROJECT_NAME__ Module Guide

Module-specific guidelines for the __PROJECT_NAME__ CLI module.

**Parent**: See `cmd/AGENTS_COMMON.md` for common rules.

---

## Module Overview

**Purpose**: Main CLI entry point for gz-__PROJECT_NAME__
**Binary**: `gz-__PROJECT_NAME__`
**Entry Point**: `main.go`

---

## File Structure

```
cmd/__PROJECT_NAME__/
├── AGENTS.md       # This file
├── main.go         # Entry point (calls Execute())
├── root.go         # Root command and subcommand registration
└── version.go      # Version information management
```

---

## Command Structure

### Root Command (`root.go`)

- Defines the root Cobra command
- Registers all subcommands in `init()`
- Handles global flags (--verbose, etc.)

### Adding New Commands

1. Create `{command}.go` file
2. Define command variable:
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
3. Register in `init()` of root.go:
   ```go
   rootCmd.AddCommand(myCmd)
   ```

---

## Key Patterns

### Flag Handling

```go
func init() {
    myCmd.Flags().StringP("output", "o", "", "Output file path")
    myCmd.Flags().BoolP("verbose", "v", false, "Verbose output")
}
```

### Error Handling

- Use `RunE` instead of `Run` for commands that can fail
- Return errors, don't `os.Exit()` directly
- Let root command handle exit codes

### Output

- Use `fmt.Println` for normal output
- Use `fmt.Fprintln(os.Stderr, ...)` for errors
- Consider structured output (JSON) with --output flag

---

## Testing

```go
func TestMyCommand(t *testing.T) {
    // Test command execution
    cmd := rootCmd
    cmd.SetArgs([]string{"mycommand", "--flag", "value"})
    err := cmd.Execute()
    assert.NoError(t, err)
}
```

---

## Dependencies

- `github.com/spf13/cobra` - CLI framework
- Internal packages from `internal/`
- Public APIs from `pkg/`

---

**Last Updated**: 2024-12-05
