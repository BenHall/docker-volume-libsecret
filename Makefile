CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
COMMIT=`git rev-parse --short HEAD`
APP=docker-volume-libsecret
REPO?=ehazlett/$(APP)
export GO15VENDOREXPERIMENT=1

all: build

add-deps:
	@godep save
	@rm -rf Godeps

build:
	@go build -ldflags "-w -X github.com/$(REPO)/version.GitCommit=$(COMMIT)" .

build-static:
	@go build -a -tags "netgo static_build" -installsuffix netgo -ldflags "-w -X github.com/$(REPO)/version.GitCommit=$(COMMIT)" .

test: build
	@go test -v ./...

clean:
	@rm $(APP)

dev:
	docker run -it --rm -w /go/src/github.com/$(APP) -v $(shell pwd)/vendor/:/go/src/ -v $(shell pwd):/go/src/github.com/$(APP) golang:1.6

.PHONY: add-deps build build-static test clean dev

