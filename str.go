package main

import (
	"os"

	"github.com/mattmc3/str/strlib"
)

var stringArgs = os.Args

const stringUsage = `string - manipulate strings

USAGE
   string <SUBCOMMAND> [flags] [STRING ...]

SUBCOMMANDS
   join       join strings with delimiter
   join0      join strings with NUL character
   length     print string lengths
   lower      convert strings to lowercase
   match      match substrings
   pad        pad strings to a fixed width
   repeat     multiply a string
   replace    replace substrings
   shorten    shorten strings to a width, with an ellipsis
   split      split strings by delimiter
   split0     split strings on NUL character
   sub        extract substrings
   trim       remove trailing whitespace
   upper      convert strings to uppercase

OPTIONS
    -h, --help     Print help.

DESCRIPTION
'str' performs operations on strings.

STRING arguments are taken from the command line unless standard input is connected to a
pipe or a file, in which case they are read from standard input, one STRING per line. It
is an error to supply STRING arguments on the command line and on standard input.

Arguments beginning with - are normally interpreted as switches; -- causes the following
arguments not to be treated as switches even if they begin with -. Switches and required
arguments are recognized only on the command line.

Most subcommands accept a -q or --quiet switch, which suppresses the usual output but
exits with the documented status. In this case these commands will quit early, without
reading all of the available input.`

func main() {
	if len(stringArgs) < 2 {
		strlib.Stderr.Println("Usage: string <command> [<args>]")
		strlib.Exit(strlib.Failure)
	}

	cmd := stringArgs[1]
	args := stringArgs[2:]
	status := 0
	switch cmd {
	case "-h", "--help":
		strlib.Stdout.Println(stringUsage)
	// case "join", "join0":
	// 	status = strlib.JoinCommand(cmd, args...)
	case "length":
		status = strlib.LengthCommand(args...)
	// case "lower", "upper":
	// 	status = strlib.ChangeCaseCommand(cmd, args...)
	default:
		strlib.Stderr.Printf("%s: invalid subcommand\n\nrun 'string -h' for help\n", cmd)
		strlib.Exit(strlib.SyntaxError)
	}
	strlib.Exit(status)
}
