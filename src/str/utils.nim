import posix

proc output*(s: string) =
  stdout.write(s)
  stdout.write('\n')

proc outerr*(s: string) =
  stderr.write(s)
  stderr.write('\n')

proc getPipedArgs*(): seq[string] =
  result = @[]
  if isatty(0) == 0:
    for line in stdin.lines:
      if line.len > 0 and line[^1] == '\r':
        result.add(line[0 ..< line.len - 1])
      else:
        result.add(line)
