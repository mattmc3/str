package main

import (
	"bytes"
	"fmt"
	"log"
	"strings"
	"testing"

	"github.com/mattmc3/str/strlib"
)

func TestHelp(t *testing.T) {
	// mocks
	var stdoutBuf bytes.Buffer
	var stderrBuf bytes.Buffer
	strlib.Stdout = log.New(&stdoutBuf, "", 0)
	strlib.Stderr = log.New(&stderrBuf, "string: ", 0)
	status := 0
	strlib.Exit = func(code int) {
		status = code
	}

	testCases := []struct {
		subcommand  string
		usagePrefix string
	}{
		// {"join", "str-join - join strings with delimiter"},
		// {"join0", "str-join - join strings with delimiter"},
		{"length", "str-length - print string lengths"},
		// {"lower", "str-lower - convert strings to lowercase"},
		// {"upper", "str-upper - convert strings to uppercase"},
	}

	for _, tc := range testCases {
		stdoutBuf.Reset()
		stderrBuf.Reset()
		stringArgs = []string{"string", tc.subcommand, "--help"}
		t.Run(fmt.Sprintf("Args: %v", stringArgs), func(t *testing.T) {
			main()
			if !strings.HasPrefix(stdoutBuf.String(), tc.usagePrefix) {
				t.Errorf("Expected usage prefix: %#v, got: %#v", tc.usagePrefix, stdoutBuf.String())
			}
			if status != strlib.Success {
				t.Errorf("Expected exit status: %v, got: %v", strlib.Success, status)
			}
		})
	}
}
