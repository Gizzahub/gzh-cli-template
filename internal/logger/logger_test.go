package logger

import (
	"bytes"
	"strings"
	"testing"
)

func TestSimpleLogger(t *testing.T) {
	var buf bytes.Buffer
	log := New("test")
	log.SetOutput(&buf)
	log.SetLevel(LevelDebug)

	log.Debug("debug message")
	log.Info("info message")
	log.Warn("warn message")
	log.Error("error message")

	output := buf.String()

	if !strings.Contains(output, "DEBUG") {
		t.Error("expected DEBUG in output")
	}
	if !strings.Contains(output, "INFO") {
		t.Error("expected INFO in output")
	}
	if !strings.Contains(output, "WARN") {
		t.Error("expected WARN in output")
	}
	if !strings.Contains(output, "ERROR") {
		t.Error("expected ERROR in output")
	}
	if !strings.Contains(output, "[test]") {
		t.Error("expected logger name in output")
	}
}

func TestLogLevel(t *testing.T) {
	var buf bytes.Buffer
	log := New("test")
	log.SetOutput(&buf)
	log.SetLevel(LevelWarn)

	log.Debug("debug")
	log.Info("info")
	log.Warn("warn")

	output := buf.String()

	if strings.Contains(output, "DEBUG") {
		t.Error("DEBUG should be filtered out")
	}
	if strings.Contains(output, "INFO") {
		t.Error("INFO should be filtered out")
	}
	if !strings.Contains(output, "WARN") {
		t.Error("WARN should be present")
	}
}

func TestWithContext(t *testing.T) {
	var buf bytes.Buffer
	log := New("test")
	log.SetOutput(&buf)

	contextLog := log.WithContext("user", "alice")
	contextLog.Info("test message")

	output := buf.String()
	if !strings.Contains(output, "user=alice") {
		t.Error("expected context in output")
	}
}

func TestLoggerWithArgs(t *testing.T) {
	var buf bytes.Buffer
	log := New("test")
	log.SetOutput(&buf)

	log.Info("operation complete", "count", 42, "status", "ok")

	output := buf.String()
	if !strings.Contains(output, "count=42") {
		t.Error("expected args in output")
	}
	if !strings.Contains(output, "status=ok") {
		t.Error("expected args in output")
	}
}

func TestLevelString(t *testing.T) {
	tests := []struct {
		level Level
		want  string
	}{
		{LevelDebug, "DEBUG"},
		{LevelInfo, "INFO"},
		{LevelWarn, "WARN"},
		{LevelError, "ERROR"},
		{Level(99), "UNKNOWN"},
	}

	for _, tt := range tests {
		if got := tt.level.String(); got != tt.want {
			t.Errorf("Level.String() = %v, want %v", got, tt.want)
		}
	}
}
