package main

// Build information - set via ldflags
var (
	Version   = "dev"
	GitCommit = "unknown"
	BuildDate = "unknown"
)

// VersionInfo contains build version information
type VersionInfo struct {
	Version   string
	GitCommit string
	BuildDate string
}

// GetVersionInfo returns current version information
func GetVersionInfo() VersionInfo {
	return VersionInfo{
		Version:   Version,
		GitCommit: GitCommit,
		BuildDate: BuildDate,
	}
}
