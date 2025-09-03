## str - manipulate strings
import std/os
import str/utils
import str/changecase
import str/length

proc strUsage*() =
  output("str [cmd] [flags...] [STRING ...]\n")

when isMainModule:
  let args = commandLineParams()

  if args.len == 0:
    strUsage()
    quit(1)

  let cmd = args[0]
  let rest =
    if args.len > 1: args[1 .. ^1]
    else: @[]

  var exitcode = 1
  case cmd
  of "lower", "upper":
    exitcode = strcaseCmd(args)
  of "length":
    exitcode = strlengthCmd(rest)
  else:
    strUsage()
    quit(1)

  quit(exitcode)
