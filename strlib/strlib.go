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

// These constants cause FlagSet.Parse to behave as described if the parse fails.
const (
	Success     = 0 // CLI code for success exit status.
	Failure     = 1 // CLI code for failure exit status.
	SyntaxError = 2 // CLI code for incorrect syntax status.
)

// standard output
var Stdout = log.New(os.Stdout, "", 0)

// standard error output
var Stderr = log.New(os.Stderr, "string: ", 0)

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
