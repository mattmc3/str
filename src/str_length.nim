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

  for kind, key, val in getopt(args):
    case kind
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
    of cmdEnd:
      discard

  var allStrings = appendPipedArgs(strings)
  return strlength(quiet, allStrings)

when isMainModule:
  import std/os
  var exitcode = strlengthCmd(commandLineParams())
  quit(exitcode)
