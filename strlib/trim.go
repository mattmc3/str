package strlib

import (
    "strings"
)

const trimUsage = `str trim - trim whitespace or characters from strings

USAGE
    str trim [-h | --help] [-q | --quiet] [-l | --left] [-r | --right] [(-c | --chars) CHARS] [STRING ...]

OPTIONS
    -h, --help     Print help.
    -q, --quiet    Suppress output, but keep exit status.
    -l, --left     Only trim leading characters.
    -r, --right    Only trim trailing characters.
    -c, --chars    Specify characters to trim instead of whitespace.

DESCRIPTION
'str trim' removes leading and/or trailing whitespace (or specified characters) from each string argument. Exit status: 0
if at least one non-empty STRING was given, or 1 otherwise.

EXAMPLES
    $ str trim '   hello, world   '
    hello, world

    $ str trim -c x 'xxhellox'
    hello
`

func TrimCommand(args ...string) int {
    trimFlagSet := NewStrFlagSet("trim")
    left := trimFlagSet.Bool("left", false, "Only trim leading characters")
    trimFlagSet.BoolVar(left, "l", false, "Only trim leading characters")
    right := trimFlagSet.Bool("right", false, "Only trim trailing characters")
    trimFlagSet.BoolVar(right, "r", false, "Only trim trailing characters")
    chars := trimFlagSet.String("chars", "", "Specify characters to trim")
    trimFlagSet.StringVar(chars, "c", "", "Specify characters to trim")
    trimFlagSet.Parse(args)
    strs := trimFlagSet.Args()

    if helpFlag {
        Stdout.Print(trimUsage)
        return Success
    }
    if len(strs) == 0 {
        return Failure
    }
    status := 1
    for _, s := range strs {
        trimmed := s
        trimChars := *chars
        if trimChars == "" {
            trimChars = " \t\n\r"
        }
        if *left && !*right {
            trimmed = strings.TrimLeft(trimmed, trimChars)
        } else if *right && !*left {
            trimmed = strings.TrimRight(trimmed, trimChars)
        } else {
            trimmed = strings.Trim(trimmed, trimChars)
        }
        if trimmed != "" {
            status = 0
        }
        if !quietFlag {
            Stdout.Print(trimmed)
        }
    }
    return status
}
