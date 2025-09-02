## str - manipulate strings

# nimble install cligen
# nimble install posix
import cligen
import posix
import std/[strutils, tables, os]

type StrTransform* = proc(s: string): string

proc output(s: string) =
  stdout.write(s)

proc outerr(s: string) =
  stderr.write(s)

proc appendPipedArgs(args: seq[string]): seq[string] =
  # Return args plus piped stdin lines, but only when no explicit args were given.
  result = @args
  if args.len == 0 and isatty(0) == 0:
    for line in stdin.lines:
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
  # Use cligen's native help/exit codes now.
  clCfg.helpSyntax = ""
  clCfg.hTabSuppress = "CLIGEN-NOHELP"

  const generalHelp = { "quiet": "Suppress output" }.toTable()

  dispatchMulti(
    [length, help=generalHelp],
    [lower,  help=generalHelp],
    [upper,  help=generalHelp],
  )
