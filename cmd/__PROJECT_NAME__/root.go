package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "gz-__PROJECT_NAME__",
	Short: "A CLI tool built with gzh-cli template",
	Long: `gz-__PROJECT_NAME__ is a CLI tool that demonstrates the standard
structure and patterns used in gzh-cli-* projects.

Use this as a starting point for building your own CLI tools.`,
}

// Execute runs the root command
func Execute() error {
	return rootCmd.Execute()
}

func init() {
	// Add global flags
	rootCmd.PersistentFlags().BoolP("verbose", "v", false, "Enable verbose output")

	// Add subcommands
	rootCmd.AddCommand(versionCmd)
	rootCmd.AddCommand(helloCmd)
}

// versionCmd shows version information
var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Show version information",
	Run: func(cmd *cobra.Command, args []string) {
		info := GetVersionInfo()
		fmt.Printf("Version:    %s\n", info.Version)
		fmt.Printf("Git Commit: %s\n", info.GitCommit)
		fmt.Printf("Build Date: %s\n", info.BuildDate)
	},
}

// helloCmd is an example command
var helloCmd = &cobra.Command{
	Use:   "hello [name]",
	Short: "Say hello",
	Long:  "A simple example command that greets the user.",
	Args:  cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		name := "World"
		if len(args) > 0 {
			name = args[0]
		}
		fmt.Printf("Hello, %s!\n", name)
	},
}
