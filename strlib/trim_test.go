package strlib

import (
    "bytes"
    "log"
    "testing"
)

func TestTrimCommand(t *testing.T) {
    tests := []struct {
        args     []string
        expected string
        status   int
    }{
        {[]string{"   foo   "}, "foo\n", 0},
        {[]string{"-l", "   foo   "}, "foo   \n", 0},
        {[]string{"-r", "   foo   "}, "   foo\n", 0},
        {[]string{"-c", "x", "xxfoo"}, "foo\n", 0},
        {[]string{"-c", "x", "-l", "xxfoo"}, "foo\n", 0},
        {[]string{"-c", "x", "-r", "fooxx"}, "foo\n", 0},
		{[]string{"-c", "x", "-r", "xxfooxx"}, "xxfoo\n", 0},
        {[]string{"-c", "xy", "xyfooxy"}, "foo\n", 0},
        {[]string{"foo"}, "foo\n", 0},
        {[]string{""}, "\n", 1},
    }

    for _, tt := range tests {
        var stdoutBuf bytes.Buffer
        var stderrBuf bytes.Buffer
        Stdout = log.New(&stdoutBuf, "", 0)
        Stderr = log.New(&stderrBuf, "str: ", 0)
        quietFlag = false
        helpFlag = false
        status := TrimCommand(tt.args...)
        got := stdoutBuf.String()
        if got != tt.expected {
            t.Errorf("TrimCommand(%v) = %q, want %q", tt.args, got, tt.expected)
        }
        if status != tt.status {
            t.Errorf("TrimCommand(%v) returned status %d, want %d", tt.args, status, tt.status)
        }
    }
}
