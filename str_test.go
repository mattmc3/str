package main

import (
	"os"
	"os/exec"
	"testing"
)

func TestStrPrintsHelloWorld(t *testing.T) {
	// Run the str program without arguments
	output, err := runStr()
	if err != nil {
		t.Fatalf("error executing str: %v", err)
	}

	// Check if output matches "Hello, world!"
	expected := "Hello, world!\n" // Expecting a newline at the end
	if output != expected {
		t.Errorf("expected '%s', got '%s'", expected, output)
	}
}

func TestStrPrintsCustomMessage(t *testing.T) {
	// Run the str program with custom arguments
	output, err := runStr("Go", "Developer")
	if err != nil {
		t.Fatalf("error executing str: %v", err)
	}

	// Check if output matches "Hello, Go Developer!"
	expected := "Hello, Go Developer!\n" // Expecting a newline at the end
	if output != expected {
		t.Errorf("expected '%s', got '%s'", expected, output)
	}
}

func runStr(args ...string) (string, error) {
	// Construct command to run str program with arguments
	cmdArgs := append([]string{"./str"}, args...)
	cmd := exec.Command(cmdArgs[0], cmdArgs[1:]...)

	// Run command and capture output
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}

	// Convert output to string
	return string(output), nil
}

func TestMain(m *testing.M) {
	// Build the str program before running the tests
	cmd := exec.Command("go", "build", "-o", "str", "str.go")
	if err := cmd.Run(); err != nil {
		println("Failed to build str:", err)
		os.Exit(1)
	}
	// Run the tests
	result := m.Run()
	// Clean up after tests
	os.Remove("str")
	os.Exit(result)
}
