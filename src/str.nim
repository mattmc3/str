import ./cli_command
import std/parseopt
import std/[os]
import std/strutils

# Swappable writers export
type StrTransform* = proc (s: string): string

# StrCommand inherits base CliCommand
type StrCommand* = ref object of CliCommand

method usage*(self: StrCommand) =
  self.output("""
Usage: str <subcommand> [args...]
Subcommands:
  upper <strings...>   Convert to UPPERCASE
  lower <strings...>   Convert to lowercase
  length <strings...>  Print length of each string
""")

proc transform(self: StrCommand, transform: StrTransform, args: seq[string]): int =
  var exitcode = 1
  for s in args:
    let newstr = transform(s)
    if newstr != s:
      exitcode = 0
    self.output(newstr & "\n")          # use output() instead of echo
  return exitcode

proc upper*(self: StrCommand, args: seq[string]): int =
  return self.transform(toUpperAscii, args)

proc lower*(self: StrCommand, args: seq[string]): int =
  return self.transform(toLowerAscii, args)

proc length*(self: StrCommand, args: seq[string]): int =
  var exitcode = 1
  for s in args:
    if s.len != 0:
      exitcode = 0
    self.output($s.len & "\n")          # use output()
  return exitcode

proc run*(self: StrCommand, args: seq[string]): int =
  if args.len == 0:
    self.usage()
    return 1
  let subcmd = args[0]
  let args = args[1..^1]
  case subcmd
  of "upper":
    return self.upper(args)
  of "lower":
    return self.lower(args)
  of "length":
    return self.length(args)
  of "help", "--help", "-h":
    self.usage()
    return 0
  else:
    self.outerr("Unknown subcommand: '" & subcmd & "'")
    self.usage()
    return 1

when isMainModule:
  var cmd = StrCommand()
  quit(cmd.run(commandLineParams()))
