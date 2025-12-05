// Package config provides application-specific configuration.
package config

import (
	"os"
	"path/filepath"

	coreconfig "github.com/gizzahub/gzh-cli-core/config"
)

// Config represents the application configuration.
type Config struct {
	// Version of the config file format
	Version string `yaml:"version"`

	// Debug enables debug mode
	Debug bool `yaml:"debug"`

	// Verbose enables verbose output
	Verbose bool `yaml:"verbose"`

	// LogLevel sets the logging level (debug, info, warn, error)
	LogLevel string `yaml:"log_level"`

	// Timeout for operations (e.g., "30s", "5m")
	Timeout string `yaml:"timeout"`

	// Custom application-specific settings
	Settings map[string]interface{} `yaml:"settings"`
}

// DefaultConfig returns the default configuration.
func DefaultConfig() *Config {
	return &Config{
		Version:  "1",
		Debug:    false,
		Verbose:  false,
		LogLevel: "info",
		Timeout:  "30s",
		Settings: make(map[string]interface{}),
	}
}

// appName is the application name for config paths.
const appName = "__PROJECT_NAME__"

// Load reads configuration from the given path.
func Load(path string) (*Config, error) {
	loader := coreconfig.NewLoader(appName)
	cfg := DefaultConfig()
	if err := loader.LoadFrom(path, cfg); err != nil {
		return nil, err
	}
	return cfg, nil
}

// LoadOrDefault loads configuration from the default locations,
// falling back to default config if not found.
func LoadOrDefault() (*Config, error) {
	loader := coreconfig.NewLoader(appName).WithPaths(ConfigPaths()...)
	cfg := DefaultConfig()
	if err := loader.LoadOrDefault(cfg); err != nil {
		return nil, err
	}
	return cfg, nil
}

// ConfigPaths returns the list of config file paths to search.
func ConfigPaths() []string {
	var paths []string

	// Current directory
	paths = append(paths, "./"+appName+".yml", "./"+appName+".yaml")

	// Home directory
	if home, err := os.UserHomeDir(); err == nil {
		configDir := filepath.Join(home, ".config", "gz-"+appName)
		paths = append(paths,
			filepath.Join(configDir, "config.yml"),
			filepath.Join(configDir, "config.yaml"),
		)
	}

	return paths
}

// Save writes configuration to the given path.
func (c *Config) Save(path string) error {
	return coreconfig.Save(path, c)
}

// Get retrieves a setting value by key.
func (c *Config) Get(key string) (interface{}, bool) {
	v, ok := c.Settings[key]
	return v, ok
}

// Set stores a setting value by key.
func (c *Config) Set(key string, value interface{}) {
	if c.Settings == nil {
		c.Settings = make(map[string]interface{})
	}
	c.Settings[key] = value
}
