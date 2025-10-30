NIM ?= nim
NIMPRETTY ?= nimpretty
SRC := src/str.nim
BIN := bin/str
TESTS := tests/test_str.nim tests/test_str_match.nim

.PHONY: build test pretty clean

build: clean
	mkdir -p bin
	$(NIM) c -d:release -o:$(BIN) $(SRC)

test: build
	@for t in $(TESTS); do \
	  echo "Running $$t"; \
	  $(NIM) r $$t || exit $$?; \
	done

pretty:
	find src tests -name '*.nim' -print0 | xargs -0 $(NIMPRETTY) --backup:off

clean:
	rm -rf -- ./bin
