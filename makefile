NIM ?= nim
SRC := src/str.nim
TEST := tests/test_str.nim
BIN := bin/str

.PHONY: build test

build: $(BIN)

$(BIN): $(SRC)
	mkdir -p bin
	$(NIM) c -d:release -o:$(BIN) $(SRC)

test:
	$(NIM) r $(TEST)
