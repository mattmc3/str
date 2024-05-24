package strlib

import (
	"bytes"
	"strings"
	"text/template"
)

func changeCaseUsage(caseName string) (string, error) {
	usageTempl := `str-{{ .case }} - convert strings to {{ .case }}case

USAGE
    str {{ .case }} [-h | --help] [-q | --quiet] [STRING ...]

OPTIONS
    -h, --help     Print help.
    -q, --quiet    Suppress output, but keep exit status.

DESCRIPTION
string {{ .case }} converts each string argument to {{ .case }}case. Exit status: 0 if at
least one string was converted to {{ .case }}case, else 1. This means that in conjunction
with the -q flag you can readily test whether a string is already {{ .case }}case.`

	t := template.Must(template.New("changeCase").Parse(usageTempl))
	data := map[string]interface{}{"case": caseName}
	var usage bytes.Buffer
	if err := t.Execute(&usage, data); err != nil {
		return "", err
	}
	return usage.String(), nil
}

// str-upper/lower - change string case
func ChangeCaseCommand(subcommand string, args ...string) int {
	changeCaseFlagSet := NewStrFlagSet("changeCase")
	changeCaseFlagSet.Parse(args)
	strs := changeCaseFlagSet.Args()

	if helpFlag {
		usage, _ := changeCaseUsage(subcommand)
		Stdout.Println(usage)
		return Success
	}

	if len(strs) == 0 {
		return 1
	}
	status := 1
	for _, s := range strs {
		var newString string
		if subcommand == "lower" {
			newString = strings.ToLower(s)
		} else {
			newString = strings.ToUpper(s)
		}
		if !quietFlag {
			Stdout.Println(newString)
		}
		if s != newString {
			status = 0
		}
	}
	return status
}
