NIM ?= nim
NIMPRETTY ?= nimpretty
SRC := src/str.nim
TEST := tests/test_str.nim
BIN := bin/str

.PHONY: build test pretty clean

build: clean
	mkdir -p bin
	$(NIM) c -d:release -o:$(BIN) $(SRC)

test: build
	$(NIM) r $(TEST)

pretty:
	find src tests -name '*.nim' -print0 | xargs -0 $(NIMPRETTY) --backup:off

clean:
	rm -rf -- ./bin
