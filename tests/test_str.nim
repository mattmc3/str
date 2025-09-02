# NIM!

import std/[os, osproc, strutils, unittest, streams]

const exeName = when defined(windows): "str.exe" else: "str"

proc buildIfNeeded() =
  let exePath = joinPath(getCurrentDir(), "bin", exeName)
  if not fileExists(exePath):
    let cmd = "nim c -d:release -o:" & exePath.quoteShell & " src/str.nim"
    let code = execCmd(cmd)
    doAssert code == 0, "Failed to build str binary"

proc runStr(args: seq[string]): tuple[code: int, stdout: string, stderr: string] =
  buildIfNeeded()
  let exePath = joinPath(getCurrentDir(), "bin", exeName)
  let p = startProcess(exePath, args = args)
  let outData = p.outputStream.readAll()
  let errData = p.errorStream.readAll()
  let code = p.waitForExit()
  p.close()
  (code, outData, errData)

# Usage / meta tests
suite "str CLI usage":
  test "usage: no args":
    let r = runStr(@[])
    check r.code == 1
    check "Usage: str" in r.stdout

  test "usage: help":
    let r = runStr(@["help"])
    check r.code == 0
    check "Subcommands:" in r.stdout

  test "unknown subcommand":
    let r = runStr(@["wat"])
    check r.code == 1
    check "Unknown subcommand" in (r.stderr & r.stdout)

# Upper subcommand
suite "str CLI upper":
  test "upper changes lowercase":
    let r = runStr(@["upper", "foo"])
    check r.stdout.strip.splitLines() == @["FOO"]
    check r.code == 0

  test "upper unchanged":
    let r = runStr(@["upper", "FOO"])
    check r.stdout.strip.splitLines() == @["FOO"]
    check r.code == 1

  test "upper mixed any change -> 0":
    let r = runStr(@["upper", "FOO", "bar"])
    check r.stdout.strip.splitLines() == @["FOO", "BAR"]
    check r.code == 0

  test "upper quiet changed":
    let r = runStr(@["upper", "-q", "foo"])
    check r.stdout.len == 0
    check r.code == 0

  test "upper quiet unchanged":
    let r = runStr(@["upper", "-q", "FOO"])
    check r.stdout.len == 0
    check r.code == 1

# Lower subcommand
suite "str CLI lower":
  test "lower changes":
    let r = runStr(@["lower", "Foo", "BAR"])
    check r.stdout.strip.splitLines() == @["foo", "bar"]
    check r.code == 0

  test "lower unchanged":
    let r = runStr(@["lower", "foo"])
    check r.stdout.strip.splitLines() == @["foo"]
    check r.code == 1

  test "lower quiet changed":
    let r = runStr(@["lower", "-q", "Foo"])
    check r.stdout.len == 0
    check r.code == 0

  test "lower quiet unchanged":
    let r = runStr(@["lower", "-q", "bar"])
    check r.stdout.len == 0
    check r.code == 1

# Length subcommand
suite "str CLI length":
  test "length prints":
    let r = runStr(@["length", "one", "three", ""])
    check r.stdout.strip.splitLines() == @["3", "5", "0"]
    check r.code == 0

  test "length with no args exit 1":
    let r = runStr(@["length"])
    check r.code == 1

  test "length quiet mixed (non-empty present)":
    let r = runStr(@["length", "-q", "a", ""])
    check r.stdout.len == 0
    check r.code == 0

  test "length quiet all empty":
    let r = runStr(@["length", "-q", "", ""])
    check r.stdout.len == 0
    check r.code == 1
