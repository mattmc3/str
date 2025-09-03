# nimble install glob
import glob
import std/parseopt
import std/strutils
import std/re # regex support
import std/sequtils # added for filterIt
import ./utils

const IsDosPlatform* = when defined(windows): true else: false

const StrMatchUsage* =
  """
string match [-a | --all] [-e | --entire] [-i | --ignore-case]
             [-g | --groups-only] [-r | --regex] [-n | --index]
             [-q | --quiet] [-v | --invert]
             PATTERN [STRING ...]
"""

proc strmatchUsage*() =
  output(StrMatchUsage)

proc strmatch*(
    allMatches, entireString, ignoreCase, groupsOnly, isRegex, index, quiet, invert:
      bool,
    maxMatches: int,
    pattern: string,
    strings: seq[string],
): int =
  if pattern.len == 0:
    outerr("str match: missing PATTERN")
    return 2
  if maxMatches < 0:
    outerr("str match: --max-matches must be >= 0")
    return 2
  if (groupsOnly) and isRegex:
    outerr("str match: --groups-only not implemented yet")
    return 2
  if (groupsOnly or index) and (not isRegex):
    outerr("str match: --groups-only / --index require --regex")
    return 2

  result = 1
  var pat = pattern
  if not isRegex:
    pat = globToRegexString(pattern, IsDosPlatform, false)

  var flags: set[re.RegexFlag]
  if ignoreCase:
    flags.incl reIgnoreCase

  var rx: re.Regex
  try:
    rx = re(pat, flags)
  except re.RegexError as ex:
    outerr("invalid regex pattern: " & ex.msg, "str match: ")
    return 2

  for s in strings:
    var matches: seq[string] = @[]

    for m in s.findAll(rx):
      matches.add(m)
      if not allMatches:
        break

    if matches.len > 0 and not invert:
      result = 0
      if not quiet:
        for mm in matches:
          if entireString:
            output(s)
          else:
            output(mm)
    elif matches.len == 0 and invert:
      result = 0
      output(s)

  return result

proc strmatchCmd*(args: seq[string]): int =
  var
    optAll, optEntire, optIgnoreCase, optGroupsOnly, optRegEx, optIndex, optQuiet,
      optInvert, optionsDone, patternSet: bool
    optMaxMatches: int
    pattern, prefix: string
    strings: seq[string] = @[]

  if args.len > 0:
    var parser = initOptParser(
      args,
      shortNoVal = {'a', 'e', 'i', 'g', 'n', 'r', 'q', 'v'},
      longNoVal =
        @[
          "all", "entire", "ignore-case", "groups-only", "regex", "index", "quiet",
          "invert",
        ],
    )

    for kind, key, val in parser.getopt():
      case kind
      of cmdEnd:
        break
      of cmdArgument:
        optionsDone = true
        # first positional is the pattern
        if not patternSet:
          patternSet = true
          pattern = key
        else:
          strings.add key
      of cmdLongOption, cmdShortOption:
        if optionsDone:
          prefix = if kind == cmdShortOption: "-" else: "--"
          if not patternSet:
            patternSet = true
            pattern = prefix & key
          else:
            strings.add prefix & key
        else:
          case key
          of "h", "help":
            strmatchUsage()
            return 0
          of "a", "all":
            optAll = true
          of "e", "entire":
            optEntire = true
          of "i", "ignore-case":
            optIgnoreCase = true
          of "g", "groups-only":
            optGroupsOnly = true
          of "r", "regex":
            optRegEx = true
          of "n", "index":
            optIndex = true
          of "q", "quiet":
            optQuiet = true
          of "v", "invert":
            optInvert = true
          of "m", "max-matches":
            if val.len == 0:
              outerr("str match: --max-matches requires a value")
              return 2
            try:
              optMaxMatches = parseInt(val)
            except ValueError:
              outerr("str match: invalid --max-matches value: " & val)
              return 2
            if optMaxMatches < 0:
              outerr("str match: --max-matches must be >= 0")
              return 2
          of "":
            optionsDone = true

  let piped = getPipedArgs()
  if strings.len > 0 and piped.len > 0:
    outerr("str match: too many arguments")
    return 2
  elif strings.len == 0 and piped.len > 0:
    strings = piped

  return strmatch(
    optAll, optEntire, optIgnoreCase, optGroupsOnly, optRegEx, optIndex, optQuiet,
    optInvert, optMaxMatches, pattern, strings,
  )

when isMainModule:
  import std/os
  var exitcode = strmatchCmd(commandLineParams())
  quit(exitcode)
