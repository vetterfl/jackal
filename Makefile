install:
	@export GO111MODULE=on && go install -ldflags="-s -w" github.com/vetterfl/jackal

install-tools:
	@export GO111MODULE=on && go get -u \
		golang.org/x/lint/golint \
		golang.org/x/tools/cmd/goimports

fmt: install-tools
	@echo "Checking go files format..."
	@GOIMP=$$(for f in $$(find . -type f -name "*.go" ! -path "./.cache/*" ! -path "./vendor/*" ! -name "bindata.go") ; do \
    		goimports -l $$f ; \
    	done) && echo $$GOIMP && test -z "$$GOIMP"

test:
	@echo "Running tests..."
	@go test -race $$(go list ./...)

coverage:
	@echo "Generating coverage profile..."
	@go test -race -coverprofile=coverage.txt -covermode=atomic $$(go list ./...)

vet:
	@echo "Searching for buggy code..."
	@go vet $$(go list ./...)

lint: install-tools
	@echo "Running linter..."
	@golint $$(go list ./...)

clean:
	@go clean
