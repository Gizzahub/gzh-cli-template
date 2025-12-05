// Package builders provides fluent test fixture builders.
package builders

// ConfigBuilder builds test Config instances with fluent interface.
type ConfigBuilder struct {
	debug    bool
	verbose  bool
	logLevel string
	timeout  string
	settings map[string]interface{}
}

// NewConfigBuilder creates a new ConfigBuilder with defaults.
func NewConfigBuilder() *ConfigBuilder {
	return &ConfigBuilder{
		debug:    false,
		verbose:  false,
		logLevel: "info",
		timeout:  "30s",
		settings: make(map[string]interface{}),
	}
}

// WithDebug sets debug mode.
func (b *ConfigBuilder) WithDebug(debug bool) *ConfigBuilder {
	b.debug = debug
	return b
}

// WithVerbose sets verbose mode.
func (b *ConfigBuilder) WithVerbose(verbose bool) *ConfigBuilder {
	b.verbose = verbose
	return b
}

// WithLogLevel sets the log level.
func (b *ConfigBuilder) WithLogLevel(level string) *ConfigBuilder {
	b.logLevel = level
	return b
}

// WithTimeout sets the timeout.
func (b *ConfigBuilder) WithTimeout(timeout string) *ConfigBuilder {
	b.timeout = timeout
	return b
}

// WithSetting adds a custom setting.
func (b *ConfigBuilder) WithSetting(key string, value interface{}) *ConfigBuilder {
	b.settings[key] = value
	return b
}

// Build returns the configuration values.
// Note: Returns raw values since this is a template.
// In actual projects, this would return *config.Config.
func (b *ConfigBuilder) Build() map[string]interface{} {
	return map[string]interface{}{
		"debug":     b.debug,
		"verbose":   b.verbose,
		"log_level": b.logLevel,
		"timeout":   b.timeout,
		"settings":  b.settings,
	}
}

// CommandBuilder builds test command scenarios.
type CommandBuilder struct {
	args   []string
	flags  map[string]string
	env    map[string]string
	stdin  string
}

// NewCommandBuilder creates a new CommandBuilder.
func NewCommandBuilder() *CommandBuilder {
	return &CommandBuilder{
		args:  []string{},
		flags: make(map[string]string),
		env:   make(map[string]string),
	}
}

// WithArgs sets command arguments.
func (b *CommandBuilder) WithArgs(args ...string) *CommandBuilder {
	b.args = args
	return b
}

// WithFlag adds a flag.
func (b *CommandBuilder) WithFlag(name, value string) *CommandBuilder {
	b.flags[name] = value
	return b
}

// WithEnv adds an environment variable.
func (b *CommandBuilder) WithEnv(key, value string) *CommandBuilder {
	b.env[key] = value
	return b
}

// WithStdin sets the stdin content.
func (b *CommandBuilder) WithStdin(stdin string) *CommandBuilder {
	b.stdin = stdin
	return b
}

// BuildArgs returns the complete argument list.
func (b *CommandBuilder) BuildArgs() []string {
	result := make([]string, 0, len(b.args)+len(b.flags)*2)
	result = append(result, b.args...)
	for name, value := range b.flags {
		if value == "" {
			result = append(result, "--"+name)
		} else {
			result = append(result, "--"+name, value)
		}
	}
	return result
}

// GetEnv returns the environment variables.
func (b *CommandBuilder) GetEnv() map[string]string {
	return b.env
}

// GetStdin returns the stdin content.
func (b *CommandBuilder) GetStdin() string {
	return b.stdin
}
