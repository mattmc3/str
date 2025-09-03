import std/parseopt
import ./utils

proc strlengthUsage*() =
  output("string length [-q | --quiet] [STRING ...]\n")

proc strlength*(quiet = false, strings: seq[string]): int =
  ## Print the length of each string.
  var exitcode = 1
  for s in strings:
    if s.len != 0:
      exitcode = 0
    if not quiet:
      output($s.len & "\n")
  return exitcode

proc strlengthCmd*(args: seq[string]): int =
  var quiet = false
  var strings: seq[string] = @[]
  var optionsDone = false

  if args.len > 0:
    for kind, key, val in getopt(args):
      case kind
      of cmdEnd:
        break
      of cmdArgument:
        strings.add key
        optionsDone = true
      of cmdLongOption, cmdShortOption:
        if optionsDone:
          var prefix = if kind == cmdShortOption: "-" else: "--"
          strings.add prefix & key
        else:
          case key:
          of "h", "help":
            strlengthUsage()
            return 0
          of "q", "quiet":
            quiet = true
          of "":
            optionsDone = true

  let piped = getPipedArgs()
  if strings.len > 0 and piped.len > 0:
    outerr("str length: too many arguments")
    return 2
  elif strings.len == 0 and piped.len > 0:
    strings = piped

  return strlength(quiet, strings)

when isMainModule:
  import std/os
  var exitcode = strlengthCmd(commandLineParams())
  quit(exitcode)
