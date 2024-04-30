# Do not remove ##? comments. They are used by 'help' to construct the help docs.
##? str - manipulate strings
##?
##? Usage:  make <command>
##?
##? Commands:

.DEFAULT_GOAL := help
all : build test testv fmt help
.PHONY : all

##? help        print this message
help:
	@grep "^##?" makefile | cut -c 5-

##? build       run build tasks
build:
	go build -o str ./str.go

##? test        run tests
test:
	go test ./... | ./bin/colorize

##? testv       run verbose tests
testv:
	go test -v ./... | ./bin/colorize

# gofmt and goimports all go files
fmt:
	find . -name '*.go' | while read -r file; do gofmt -w -s "$$file"; goimports -w "$$file"; done
