import posix
import std/strutils

proc output*(s: string) =
  stdout.writeLine(s)

proc outerr*(s: string, prefix = "") =
  let newStr = s.strip(leading = false)
  for line in newStr.splitLines(keepEol = false):
    stderr.write(prefix)
    stderr.writeLine(line)

proc getPipedArgs*(): seq[string] =
  result = @[]
  if isatty(0) == 0:
    for line in stdin.lines:
      if line.len > 0 and line[^1] == '\r':
        result.add(line[0 ..< line.len - 1])
      else:
        result.add(line)
