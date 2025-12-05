package config

import (
	"os"
	"path/filepath"
	"testing"
)

func TestDefaultConfig(t *testing.T) {
	cfg := DefaultConfig()

	if cfg.Version != "1" {
		t.Errorf("expected version 1, got %s", cfg.Version)
	}
	if cfg.Debug != false {
		t.Error("expected debug to be false")
	}
	if cfg.LogLevel != "info" {
		t.Errorf("expected log_level info, got %s", cfg.LogLevel)
	}
	if cfg.Settings == nil {
		t.Error("expected settings to be initialized")
	}
}

func TestLoadConfig(t *testing.T) {
	// Create temp config file
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "config.yml")

	content := `
version: "2"
debug: true
verbose: true
log_level: debug
timeout: "1m"
settings:
  key1: value1
  key2: 42
`
	if err := os.WriteFile(configPath, []byte(content), 0o644); err != nil {
		t.Fatalf("failed to write test config: %v", err)
	}

	cfg, err := Load(configPath)
	if err != nil {
		t.Fatalf("failed to load config: %v", err)
	}

	if cfg.Version != "2" {
		t.Errorf("expected version 2, got %s", cfg.Version)
	}
	if !cfg.Debug {
		t.Error("expected debug to be true")
	}
	if cfg.LogLevel != "debug" {
		t.Errorf("expected log_level debug, got %s", cfg.LogLevel)
	}
}

func TestSaveConfig(t *testing.T) {
	tmpDir := t.TempDir()
	configPath := filepath.Join(tmpDir, "subdir", "config.yml")

	cfg := DefaultConfig()
	cfg.Debug = true
	cfg.Set("test_key", "test_value")

	if err := cfg.Save(configPath); err != nil {
		t.Fatalf("failed to save config: %v", err)
	}

	// Reload and verify
	loaded, err := Load(configPath)
	if err != nil {
		t.Fatalf("failed to reload config: %v", err)
	}

	if !loaded.Debug {
		t.Error("expected debug to be true after reload")
	}

	if v, ok := loaded.Get("test_key"); !ok || v != "test_value" {
		t.Error("expected test_key to be preserved")
	}
}

func TestGetSet(t *testing.T) {
	cfg := DefaultConfig()

	// Get non-existent key
	if _, ok := cfg.Get("nonexistent"); ok {
		t.Error("expected Get to return false for nonexistent key")
	}

	// Set and Get
	cfg.Set("mykey", "myvalue")
	if v, ok := cfg.Get("mykey"); !ok || v != "myvalue" {
		t.Error("expected Get to return set value")
	}
}

func TestConfigPaths(t *testing.T) {
	paths := ConfigPaths()
	if len(paths) == 0 {
		t.Error("expected at least one config path")
	}
}
