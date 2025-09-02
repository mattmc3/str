# CLI command base type

# Swappable writers export
type Writer* = proc (s: string)

# Base command providing writer hooks
type CliCommand* = ref object of RootObj
  outWriter*: Writer
  errWriter*: Writer
  quiet*: bool                 # suppress normal output when true

# Abstract-like usage method: must be overridden by subclasses
method usage*(self: CliCommand) {.base.} =
  raise newException(CatchableError, "usage() not implemented")

proc output*(self: CliCommand, s: string) =
  if self.quiet: return         # suppress stdout when quiet
  if self.outWriter == nil: stdout.write(s) else: self.outWriter(s)

proc outerr*(self: CliCommand, s: string) =
  if self.errWriter == nil: stderr.write(s) else: self.errWriter(s)
