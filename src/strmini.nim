## str - manipulate strings

# nimble install cligen
# nimble install posix
import cligen
import posix
import std/strutils

type StrTransform* = proc(s: string): string

proc output(s: string) =
  stdout.write(s)

proc outerr(s: string) =
  stderr.write(s)

proc appendPipedArgs(args: seq[string]): seq[string] =
  # Return args with any piped stdin lines appended.
  # If stdin is a tty, returns args unchanged.
  result = @args
  if isatty(0) == 0:
    for line in stdin.lines:
      # Preserve empty lines as empty-string arguments.
      if line.len > 0 and line[^1] == '\r':
        result.add(line[0 ..< line.len-1])
      else:
        result.add(line)

proc length*(quiet = false, args: seq[string]): int =
  ## Print the length of each string.
  let allArgs = appendPipedArgs(args)
  var exitcode = 1
  for s in allArgs:
    if s.len != 0:
      exitcode = 0
    if not quiet: output($s.len & "\n")
  return exitcode

proc transform(transform: StrTransform, quiet = false, args: seq[string]): int =
  let allArgs = appendPipedArgs(args)
  var exitcode = 1
  for s in allArgs:
    let newstr = transform(s)
    if newstr != s:
      exitcode = 0
    if not quiet: output(newstr & "\n")
  return exitcode

proc lower*(quiet = false, args: seq[string]): int =
  ## Lowercase each string argument
  return transform(toLowerAscii, quiet, args)

proc upper*(quiet = false, args: seq[string]): int =
  ## Uppercase each string argument
  return transform(toUpperAscii, quiet, args)

when isMainModule:
  #var quietHelp = { "quiet": "Suppress output" }.toTable()
  #clCfg.clUseMultiGeneral = ""
  clCfg.helpSyntax = ""
  clCfg.hTabSuppress = "CLIGEN-NOHELP"
  dispatchMulti(
    [length, help={"quiet": "Suppress output"}],
    [lower, help={"quiet": "Suppress output"}],
    [upper, help={"quiet": "Suppress output"}]
  )
  # dispatchMulti(
  #   [
  #     collect, escape, join, join0, length, lower, match,
  #     pad, repeat, repeatAlt, replace, shorten,
  #     split, split0, sub, trim, unescape, upper
  #   ],
  #   cmdName = "str",
  #   clCfg = ClCfg(
  #     short = {
  #       "noTrimNewlines": 'N',   # override default 'n'
  #       "noNewline": 'N'         # override default 'n'
  #     },
  #     long = {
  #       "noTrimNewlines": "no-trim-newlines", # dashed style
  #       "noEmpty": "no-empty",
  #       "noQuoted": "no-quoted",
  #       "ignoreCase": "ignore-case",
  #       "groupsOnly": "groups-only",
  #       "noNewline": "no-newline"
  #     }
  #   )
  # )
