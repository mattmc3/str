# NIM!

import std/[os, osproc, strutils, unittest, streams]  # added streams for readAll(Stream)

const exeName = when defined(windows): "str.exe" else: "str"

proc buildIfNeeded() =
  let exePath = joinPath(getCurrentDir(), "bin", exeName)
  if not fileExists(exePath):
    echo "Building str binary for tests..."
    let cmd = "nim c -d:release -o:" & exePath.quoteShell & " src/str.nim"
    let code = execCmd(cmd)
    doAssert code == 0, "Failed to build str binary"
  else:
    discard

proc runStr(args: seq[string]): tuple[code: int, stdout: string, stderr: string] =
  buildIfNeeded()
  let exePath = joinPath(getCurrentDir(), "bin", exeName)
  # Start process
  let p = startProcess(exePath, args = args)
  # Read all (outputs are tiny; deadlock unlikely)
  let outData = p.outputStream.readAll()
  let errData = p.errorStream.readAll()
  let code = p.waitForExit()
  p.close()
  (code, outData, errData)

suite "str CLI":
  test "no args shows usage and exit code 1":
    let r = runStr(@[])
    check r.code == 1
    check "Usage: str" in r.stdout

  test "help shows usage and exit code 0":
    let r = runStr(@["help"])
    check r.code == 0
    check "Subcommands:" in r.stdout

  test "upper changes lowercase -> exit 0 (changed)":
    let r = runStr(@["upper", "foo"])
    check r.stdout.strip == "FOO"
    check r.code == 0

  test "upper unchanged string -> exit 1 (no changes)":
    let r = runStr(@["upper", "FOO"])
    check r.stdout.strip == "FOO"
    check r.code == 1

  test "upper mixed args any change yields 0":
    let r = runStr(@["upper", "FOO", "bar"])
    # Order preserved; two lines
    let lines = r.stdout.strip.splitLines()
    check lines.len == 2
    check lines[0] == "FOO"
    check lines[1] == "BAR"
    check r.code == 0          # because 'bar' changed

  test "lower works":
    let r = runStr(@["lower", "Foo", "BAR"])
    let lines = r.stdout.strip.splitLines()
    check lines == @["foo", "bar"]
    check r.code == 0          # both changed

  test "lower unchanged returns 1":
    let r = runStr(@["lower", "foo"])
    check r.stdout.strip == "foo"
    check r.code == 1

  test "length prints lengths (exit 0)":
    let r = runStr(@["length", "one", "three", ""])
    let lines = r.stdout.strip.splitLines()
    check lines == @["3", "5", "0"]
    check r.code == 0

  test "length with no args exit 1":
    let r = runStr(@["length"])
    check r.code == 1

  test "unknown subcommand":
    let r = runStr(@["wat"])
    check r.code == 1
    check "Unknown subcommand" in (r.stderr & r.stdout)  # stderr + usage on stdout

# Tests auto-run via std/unittest registration; no explicit runner needed.
when isMainModule:
  discard
