package strlib

import (
	"bytes"
	"fmt"
	"log"
	"testing"
)

func TestLengthCommand(t *testing.T) {
	// Create mock writers
	var stdoutBuf bytes.Buffer
	var stderrBuf bytes.Buffer
	Stdout = log.New(&stdoutBuf, "", 0)
	Stderr = log.New(&stderrBuf, "string: ", 0)
	Exit = func(status int) {
	}

	testCases := []struct {
		args   []string
		output string
		status int
	}{

		{[]string{}, "", Failure},
		{[]string{"", "", ""}, "0\n0\n0\n", Failure},
		{[]string{"hello, world"}, "12\n", Success},
		{[]string{"a", "bb", "ccc"}, "1\n2\n3\n", Success},
		{[]string{"--quiet", "a", "bb", "ccc"}, "", Success},
		{[]string{"-q"}, "", Failure},
		{[]string{"--", "-q"}, "2\n", Success},
	}

	for _, tc := range testCases {
		stdoutBuf.Reset()
		stderrBuf.Reset()
		t.Run(fmt.Sprintf("Args: %v", tc.args), func(t *testing.T) {
			status := LengthCommand(tc.args...)
			if tc.output != stdoutBuf.String() {
				t.Errorf("Expected output: %#v, got: %#v", tc.output, stdoutBuf.String())
			}
			if tc.status != status {
				t.Errorf("Expected exit status: %v, got: %v", tc.status, status)
			}
		})
	}
}
