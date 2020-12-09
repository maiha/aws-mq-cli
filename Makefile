DOCKER ?= docker run -t -u "`id -u`:`id -g`" -v "$(PWD):/v" -w /v --rm crystallang/crystal:0.35.1-alpine

all: aws-mq-cli-dev
release: aws-mq-cli

######################################################################
### Compiling

# optimized binary for benchmark
aws-mq-cli:
	$(DOCKER) shards build --link-flags "-static" --release "$@"

# fast compilation for develop
aws-mq-cli-dev:
	$(DOCKER) shards build --link-flags "-static" "$@"

clean:
	rm -rf bin lib .crystal .shards

######################################################################
### Versioning

VERSION=
CURRENT_VERSION=$(shell git tag -l | sort -V | tail -1 | sed -e 's/^v//')
GUESSED_VERSION=$(shell git tag -l | sort -V | tail -1 | awk 'BEGIN { FS="." } { $$3++; } { printf "%d.%d.%d", $$1, $$2, $$3 }')

.PHONY : version
version:
	@if [ "$(VERSION)" = "" ]; then \
	  echo "ERROR: specify VERSION as bellow. (current: $(CURRENT_VERSION))";\
	  echo "  make version VERSION=$(GUESSED_VERSION)";\
	else \
	  sed -i -e 's/^version: .*/version: $(VERSION)/' shard.yml ;\
	  echo git commit -a -m "'$(COMMIT_MESSAGE)'" ;\
	  git commit -a -m 'version: $(VERSION)' ;\
	  git tag "v$(VERSION)" ;\
	fi

.PHONY : bump
bump:
	make version VERSION=$(GUESSED_VERSION) -s
