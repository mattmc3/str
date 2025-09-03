import std/parseopt
import std/strutils as su
import ./utils

type StrTransform* = proc(s: string): string

proc strcaseUsage*() =
  output("string lower [-q | --quiet] [STRING ...]\n")
  output("string upper [-q | --quiet] [STRING ...]\n")

proc strcase*(transform: StrTransform, quiet = false, strings: seq[string]): int =
  ## Change the case for each string argument
  var exitcode = 1
  for s in strings:
    let newstr = transform(s)
    if newstr != s:
      exitcode = 0
    if not quiet:
      output(newstr & "\n")
  return exitcode

proc strcaseCmd*(args: seq[string]): int =
  if args.len == 0:
    strcaseUsage()
    return 1

  let cmd = args[0]
  var transform: StrTransform
  case cmd
  of "lower":
    transform = su.toLowerAscii
  of "upper":
    transform = su.toUpperAscii
  else:
    strcaseUsage()
    return 1

  let rest =
    if args.len > 1: args[1 .. ^1]
    else: @[]

  var quiet = false
  var strings: seq[string] = @[]
  var optionsDone = false

  for kind, key, val in getopt(rest):
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
          strcaseUsage()
          return 0
        of "q", "quiet":
          quiet = true
        of "":
          optionsDone = true
    of cmdEnd:
      discard

  var allStrings = appendPipedArgs(strings)
  return strcase(transform, quiet, allStrings)

when isMainModule:
  import std/os
  var exitcode = strcaseCmd(commandLineParams())
  quit(exitcode)
