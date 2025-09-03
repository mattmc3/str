## str - manipulate strings
import std/os
import str/utils
import str/changecase
import str/length

const StrUsageText* =
  """str - manipulate strings

Usage:
  str [command] [options] [STRING ...]

Commands:
  help    print comprehensive or per-cmd help
  lower   convert strings to lower case
  upper   convert strings to upper case
  length  print length of strings
"""

proc strUsage*() =
  output(StrUsageText & "\n")

when isMainModule:
  let args = commandLineParams()

  if args.len == 0:
    outerr("str: missing subcommand\n")
    quit(2)

  let cmd = args[0]
  let rest =
    if args.len > 1:
      args[1 .. ^1]
    else:
      @[]

  var exitcode = 0
  case cmd
  of "lower", "upper":
    exitcode = strcaseCmd(cmd, rest)
  of "length":
    exitcode = strlengthCmd(rest)
  of "-h", "--help", "help":
    strUsage()
  else:
    outerr("str: invalid subcommand")
    quit(2)

  quit(exitcode)
