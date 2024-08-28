VERSION_TXT    := version.txt
FILE_VERSION   := $(shell cat $(VERSION_TXT))
VERSION        ?= $(FILE_VERSION)
RELEASE        := v$(VERSION)
SEMVER_REGEX   := ^([0-9]+)\.([0-9]+)\.([0-9]+)(-([0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?(\+[0-9A-Za-z-]+)?$
IMPORT_SOURCES := https://github.com/getupcloud/managed-cluster/raw/main/templates/variables-common.tf

.ONESHELL:

import:
	$(foreach i,$(filter https://% http://%, $(IMPORT_SOURCES)),curl -sLO $(i);)
	$(foreach i,$(filter-out https://% http://%, $(IMPORT_SOURCES)),cp -f $(i) ./;)

modules: variables-modules-merge.tf.json
variables-modules-merge.tf.json: variables-modules.tf
	./make-modules $< > $@

test: modules fmt lint init validate
	$(MAKE) -C test/

clean:
	rm -rf ./.terraform ./.terraform.lock.hcl
	$(MAKE) -C test/ clean

i init:
	terraform init

l lint:
	@type tflint &>/dev/null || echo "Ignoring not found: tflint" && tflint
	if ! [[ "$(VERSION)" =~ $(SEMVER_REGEX) ]]; then
		echo Invalid semantic version: $(VERSION) >&2;
		exit 1;
	fi

v validate:
	terraform validate

f fmt:
	terraform fmt

release: import modules fmt update-version
	$(MAKE) build-release

update-version:
	@if git status --porcelain | grep '^[^?]' | grep -vq $(VERSION_TXT); then
		git status;
		echo -e "\n>>> Tree is not clean. Please commit and try again <<<\n";
		exit 1;
	fi
	[ -n "$$BUILD_VERSION" ] || read -e -i "$(FILE_VERSION)" -p "New version: " BUILD_VERSION
	echo $$BUILD_VERSION > $(VERSION_TXT)

build-release:
	git pull --tags
	git commit -m "Built release $(RELEASE)" $(VERSION_TXT)
	git tag $(RELEASE)
	git push --tags
	git push
