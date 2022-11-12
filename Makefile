VERSION_TXT    := version.txt
FILE_VERSION   := $(shell cat $(VERSION_TXT))
VERSION        ?= $(FILE_VERSION)
RELEASE        := v$(VERSION)
SEMVER_REGEX   := ^([0-9]+)\.([0-9]+)\.([0-9]+)(-([0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?(\+[0-9A-Za-z-]+)?$
IMPORT_SOURCES := https://github.com/getupcloud/managed-cluster/raw/main/templates/variables-common.tf

import:
	$(foreach i,$(filter https://% http://%, $(IMPORT_SOURCES)),curl -sLO $(i);)
	$(foreach i,$(filter /%, $(IMPORT_SOURCES)),cp -f $(i) ./;)

test: fmt lint init validate

i init:
	terraform init

l lint:
	@type tflint &>/dev/null || echo "Ignoring not found: tflint" && tflint
	@if ! [[ "$(VERSION)" =~ $(SEMVER_REGEX) ]]; then \
		echo Invalid semantic version: $(VERSION) >&2; \
		exit 1; \
	fi

v validate:
	terraform validate

f fmt:
	terraform fmt

release:
	@if git status --porcelain | grep '^[^?]' | grep -vq $(VERSION_TXT); then \
		git status; \
		echo -e "\n>>> Tree is not clean. Please commit and try again <<<\n"; \
		exit 1; \
	fi
	git pull --tags
	git commit -m "Built release $(RELEASE)" $(VERSION_TXT)
	git tag $(RELEASE)
	git push --tags
	git push