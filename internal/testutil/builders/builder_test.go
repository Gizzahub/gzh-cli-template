package builders

import (
	"testing"
)

func TestConfigBuilder(t *testing.T) {
	cfg := NewConfigBuilder().
		WithDebug(true).
		WithVerbose(true).
		WithLogLevel("debug").
		WithTimeout("1m").
		WithSetting("key1", "value1").
		Build()

	if cfg["debug"] != true {
		t.Error("expected debug to be true")
	}
	if cfg["verbose"] != true {
		t.Error("expected verbose to be true")
	}
	if cfg["log_level"] != "debug" {
		t.Error("expected log_level to be debug")
	}
	if cfg["timeout"] != "1m" {
		t.Error("expected timeout to be 1m")
	}

	settings := cfg["settings"].(map[string]interface{})
	if settings["key1"] != "value1" {
		t.Error("expected key1 setting")
	}
}

func TestCommandBuilder(t *testing.T) {
	cmd := NewCommandBuilder().
		WithArgs("subcommand", "arg1").
		WithFlag("verbose", "").
		WithFlag("output", "file.txt").
		WithEnv("DEBUG", "1").
		WithStdin("input data")

	args := cmd.BuildArgs()

	// Check args are present
	found := false
	for _, arg := range args {
		if arg == "subcommand" {
			found = true
			break
		}
	}
	if !found {
		t.Error("expected subcommand in args")
	}

	// Check flags
	hasVerbose := false
	hasOutput := false
	for i, arg := range args {
		if arg == "--verbose" {
			hasVerbose = true
		}
		if arg == "--output" && i+1 < len(args) && args[i+1] == "file.txt" {
			hasOutput = true
		}
	}
	if !hasVerbose {
		t.Error("expected --verbose flag")
	}
	if !hasOutput {
		t.Error("expected --output flag with value")
	}

	// Check env
	env := cmd.GetEnv()
	if env["DEBUG"] != "1" {
		t.Error("expected DEBUG env var")
	}

	// Check stdin
	if cmd.GetStdin() != "input data" {
		t.Error("expected stdin content")
	}
}

func TestBuilderDefaults(t *testing.T) {
	cfg := NewConfigBuilder().Build()

	if cfg["debug"] != false {
		t.Error("expected debug default to be false")
	}
	if cfg["log_level"] != "info" {
		t.Error("expected log_level default to be info")
	}
}
