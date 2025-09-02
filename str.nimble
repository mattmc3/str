# str.nimble - Nimble package definition

version       = "0.1.0"
author        = "mattmc3"
description   = "String CLI utility"
license       = "MIT"

# Project layout
srcDir        = "src"
bin           = @["str"]   # builds src/str.nim as executable

# Minimum Nim version
requires "nim >= 2.0.0"

# Add external dependencies here, e.g. when argparse is adopted:
requires "cligen >= 1.9.0"

# Optional custom tasks (uncomment if needed)
# task test, "Run tests":
#   exec "nim c -r tests/test_all.nim"
