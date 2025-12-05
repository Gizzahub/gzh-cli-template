// Package config provides configuration management utilities.
package config

import (
	"fmt"
	"os"
	"path/filepath"

	"gopkg.in/yaml.v3"
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

// Load reads configuration from the given path.
func Load(path string) (*Config, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("reading config file: %w", err)
	}

	cfg := DefaultConfig()
	if err := yaml.Unmarshal(data, cfg); err != nil {
		return nil, fmt.Errorf("parsing config file: %w", err)
	}

	return cfg, nil
}

// LoadOrDefault loads configuration from the default locations,
// falling back to default config if not found.
func LoadOrDefault() (*Config, error) {
	paths := ConfigPaths()

	for _, path := range paths {
		if _, err := os.Stat(path); err == nil {
			return Load(path)
		}
	}

	return DefaultConfig(), nil
}

// ConfigPaths returns the list of config file paths to search.
func ConfigPaths() []string {
	var paths []string

	// Current directory
	paths = append(paths, "./__PROJECT_NAME__.yml", "./__PROJECT_NAME__.yaml")

	// Home directory
	if home, err := os.UserHomeDir(); err == nil {
		configDir := filepath.Join(home, ".config", "gz-__PROJECT_NAME__")
		paths = append(paths,
			filepath.Join(configDir, "config.yml"),
			filepath.Join(configDir, "config.yaml"),
		)
	}

	return paths
}

// Save writes configuration to the given path.
func (c *Config) Save(path string) error {
	// Ensure directory exists
	dir := filepath.Dir(path)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return fmt.Errorf("creating config directory: %w", err)
	}

	data, err := yaml.Marshal(c)
	if err != nil {
		return fmt.Errorf("marshaling config: %w", err)
	}

	if err := os.WriteFile(path, data, 0o644); err != nil {
		return fmt.Errorf("writing config file: %w", err)
	}

	return nil
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
