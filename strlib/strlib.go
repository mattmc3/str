package strlib

import (
	"flag"
	"log"
	"os"
)

// type StrError struct {
// 	StatusCode int
// 	Err        error
// }

// func (se *StrError) Error() string {
// 	return fmt.Sprintf("str: %v", se.Err)
// }

// Exit status.
const (
	Success     = 0 // Success exit status.
	Failure     = 1 // Failure exit status.
	SyntaxError = 2 // Incorrect syntax status.
)

// standard output
var Stdout = log.New(os.Stdout, "", 0)

// standard error output
var Stderr = log.New(os.Stderr, "str: ", 0)

// standard input
var Stdin = os.Stdin

// Wrap os.Exit so it can be mocked during testing
var Exit = func(status int) {
	os.Exit(status)
}

var (
	quietFlag bool
	helpFlag  bool
)

func NewStrFlagSet(name string) *flag.FlagSet {
	fs := flag.NewFlagSet(name, flag.ExitOnError)
	// handle the -h/--help flag rather than letting the flag library do it so that
	// ExitOnError issues will show just a short usage string and -h/--help can show
	// the subcommand's help.
	fs.BoolVar(&helpFlag, "h", false, "Print help.")
	fs.BoolVar(&helpFlag, "help", false, "Print help.")
	fs.BoolVar(&quietFlag, "q", false, "Suppress output, but keep exit status.")
	fs.BoolVar(&quietFlag, "quiet", false, "Suppress output, but keep exit status.")
	fs.Usage = func() {
		Stdout.Println("type 'str -h' or 'str <SUBCOMMAND> -h' for help.")
	}
	return fs
}
