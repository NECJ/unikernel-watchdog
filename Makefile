Version := $(shell git describe --tags --dirty)
# Version := "dev"
GitCommit := $(shell git rev-parse HEAD)
LDFLAGS := "-s -w -X main.Version=$(Version) -X main.GitCommit=$(GitCommit)"

.PHONY: all
all: gofmt test dist hashgen

.PHONY: test
test: 
	go test -v ./...

.PHONY: hashgen
hashgen: 
	./ci/hashgen.sh

.PHONY: gofmt
gofmt:
	@echo "+ $@"
	@gofmt -l -d $(shell find . -type f -name '*.go' -not -path "./vendor/*")

.PHONY: dist
dist: 
	CGO_ENABLED=0 GOOS=linux go build -mod=vendor -a -ldflags $(LDFLAGS) -installsuffix cgo -o bin/fwatchdog-amd64

.PHONY: deploy
deploy: dist
	docker build -t unikernel-watchdog .
	docker tag unikernel-watchdog:latest public.ecr.aws/t7r4r6l6/unikernel-watchdog:latest
	docker push public.ecr.aws/t7r4r6l6/unikernel-watchdog:latest