package strlib

const lengthUsage = `str-length - print string lengths

USAGE
    str length [-h | --help] [-q | --quiet] [STRING ...]

OPTIONS
    -h, --help     Print help.
    -q, --quiet    Suppress output, but keep exit status.

DESCRIPTION
'str length' reports the length of each string argument in characters. Exit status: 0
if at least one non-empty STRING was given, or 1 otherwise.

EXAMPLES
    $ str length 'hello, world'
    12

    $ s=foo
    $ str length -q $s; echo $?
    0
    $ # Equivalent to test -n "$s"`

// str-length - print string lengths
func LengthCommand(args ...string) int {
	lengthFlagSet := NewStrFlagSet("length")
	lengthFlagSet.Parse(args)
	strs := lengthFlagSet.Args()

	// show the subcommand help
	if helpFlag {
		Stdout.Println(lengthUsage)
		return Success
	}

	if len(strs) == 0 {
		return Failure
	}
	status := 1
	for _, s := range strs {
		length := len(s)
		if length > 0 {
			status = 0
		}
		if !quietFlag {
			Stdout.Println(length)
		}
	}
	return status
}
