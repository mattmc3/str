package strlib

import (
	"bytes"
	"fmt"
	"log"
	"testing"
)

func TestChangeCaseCommand(t *testing.T) {
	// mocks
	var stdoutBuf bytes.Buffer
	var stderrBuf bytes.Buffer
	Stdout = log.New(&stdoutBuf, "", 0)
	Stderr = log.New(&stderrBuf, "str: ", 0)
	Exit = func(code int) {
	}

	testCases := []struct {
		subcommand string
		args       []string
		output     string
		status     int
	}{
		{"upper", []string{}, "", Failure},
		{"upper", []string{"", "", ""}, "\n\n\n", Failure},
		{"upper", []string{"FOO", "bar", "Baz"}, "FOO\nBAR\nBAZ\n", Success},
		{"upper", []string{"hello, world"}, "HELLO, WORLD\n", Success},
		{"upper", []string{"Hello, World"}, "HELLO, WORLD\n", Success},
		{"upper", []string{"HELLO, WORLD"}, "HELLO, WORLD\n", Failure},
		{"upper", []string{"--", "-h", "--help"}, "-H\n--HELP\n", Success},

		{"lower", []string{}, "", Failure},
		{"lower", []string{"", "", ""}, "\n\n\n", Failure},
		{"lower", []string{"FOO", "bar", "Baz"}, "foo\nbar\nbaz\n", Success},
		{"lower", []string{"hello, world"}, "hello, world\n", Failure},
		{"lower", []string{"Hello, World"}, "hello, world\n", Success},
		{"lower", []string{"HELLO, WORLD"}, "hello, world\n", Success},
		{"lower", []string{"--", "-h", "--HELP"}, "-h\n--help\n", Success},
	}

	for _, tc := range testCases {
		stdoutBuf.Reset()
		stderrBuf.Reset()
		t.Run(fmt.Sprintf("Args: %v", tc.args), func(t *testing.T) {
			status := ChangeCaseCommand(tc.subcommand, tc.args...)
			if tc.output != stdoutBuf.String() {
				t.Errorf("Expected output: %#v, got: %#v", tc.output, stdoutBuf.String())
			}
			if tc.status != status {
				t.Errorf("Expected exit status: %v, got: %v", tc.status, status)
			}
		})
	}
}
