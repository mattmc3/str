import posix

proc output*(s: string) =
  stdout.write(s)

proc outerr*(s: string) =
  stderr.write(s)

proc appendPipedArgs*(args: seq[string]): seq[string] =
  # Return args plus piped stdin lines, but only when no explicit args were given.
  result = @args
  if args.len == 0 and isatty(0) == 0:
    for line in stdin.lines:
      if line.len > 0 and line[^1] == '\r':
        result.add(line[0 ..< line.len - 1])
      else:
        result.add(line)
