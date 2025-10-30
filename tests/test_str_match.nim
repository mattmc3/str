import std/[os, osproc, strutils, unittest, streams]

const exeName = when defined(windows): "str.exe" else: "str"

proc buildIfNeeded() =
  let exePath = joinPath(getCurrentDir(), "bin", exeName)
  if not fileExists(exePath):
    let cmd = "nim c -d:release -o:" & exePath.quoteShell & " src/str.nim"
    let code = execCmd(cmd)
    doAssert code == 0, "Failed to build str binary"

proc runMatch(
    args: seq[string], stdinData = ""
): tuple[code: int, stdout: string, stderr: string] =
  buildIfNeeded()
  let exePath = joinPath(getCurrentDir(), "bin", exeName)
  # Prepend subcommand "match"
  let fullArgs = @["match"] & args
  let p = startProcess(exePath, args = fullArgs)
  if stdinData.len > 0:
    p.inputStream.write(stdinData)
  # Close stdin so the program does not wait for more piped data
  p.inputStream.close()
  let outData = p.outputStream.readAll()
  let errData = p.errorStream.readAll()
  let code = p.waitForExit()
  p.close()
  (code, outData, errData)

suite "str match basic (from fish examples)":
  test "invert regex prints non-matching (dog diz)":
    let r = runMatch(@["-r", "-v", "c.*", "dog", "can", "cat", "diz"])
    check r.code == 0
    check r.stdout.strip.splitLines() == @["dog", "diz"]

  test "invert regex quiet exit 0":
    let r = runMatch(@["-q", "-r", "-v", "c.*", "dog", "can", "cat", "diz"])
    check r.code == 0
    check r.stdout.len == 0

  test "glob max-matches 2 (*at) cat bat":
    let r = runMatch(@["-m2", "*at", "dog", "cat", "bat", "gnat"])
    check r.code == 0
    check r.stdout.strip.splitLines() == @["cat", "bat"]

  test "regex invert max-matches 1 at$ (only dog)":
    let r = runMatch(@["-r", "-v", "-m1", "at$", "dog", "cat", "bat", "hog"])
    check r.code == 0
    check r.stdout.strip.splitLines() == @["dog"]
