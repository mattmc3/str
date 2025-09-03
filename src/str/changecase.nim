import std/parseopt
import std/strutils as su
import ./utils

type StrTransform* = proc(s: string): string

proc strcaseUsage*() =
  output("string lower [-q | --quiet] [STRING ...]")
  output("string upper [-q | --quiet] [STRING ...]")

proc strcase*(transform: StrTransform, quiet = false, strings: seq[string]): int =
  ## Change the case for each string argument
  var exitcode = 1
  for s in strings:
    let newstr = transform(s)
    if newstr != s:
      exitcode = 0
    if not quiet:
      output(newstr)
  return exitcode

proc strcaseCmd*(cmd: string, args: seq[string]): int =
  if args.len == 0:
    strcaseUsage()
    return 1

  var transform: StrTransform
  case cmd
  of "lower":
    transform = su.toLowerAscii
  of "upper":
    transform = su.toUpperAscii
  else:
    strcaseUsage()
    return 1

  var quiet = false
  var strings: seq[string] = @[]
  var optionsDone = false

  if args.len > 0:
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
          case key
          of "h", "help":
            strcaseUsage()
            return 0
          of "q", "quiet":
            quiet = true
          of "":
            optionsDone = true
      of cmdEnd:
        discard

  let piped = getPipedArgs()
  if strings.len > 0 and piped.len > 0:
    outerr("str length: too many arguments")
    return 2
  elif strings.len == 0 and piped.len > 0:
    strings = piped

  return strcase(transform, quiet, strings)

when isMainModule:
  import std/os
  var args = commandLineParams()
  var subcmd = args[0]
  var rest = args[1 ..^ 1]
  var exitcode = strcaseCmd(subcmd, rest)
  quit(exitcode)
