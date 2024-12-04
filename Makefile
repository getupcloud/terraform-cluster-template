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

update-module-versions:
	@modules=$$(hcl2json < main.tf  | jq '.module|keys|.[]' -r 2>/dev/null) || true
	if [ -n "$$modules" ]; then
		for module in $$modules; do
			source=$$(hcl2json < main.tf | jq ".module[\"$$module\"][0].source" -r)
			url=$$(./urlparse "$$source" "https://{netloc}{path}/raw/refs/heads/main/version.txt")
			ref=$$(./urlparse "$$source" "{query[ref]}")
			echo -n "$$url"
			if ! new_ver=$$(curl --fail -sL "$$url"); then
				printf "\r[ Not Found ] $$url\n"
				continue
			fi
			[ "$${ref:0:1}" == v ] && cur_ver="$${ref:1}" || cur_ver="$$ver"
			if [ "$$cur_ver" != "$$new_ver" ]; then
				printf "\r[  $(COLOR_GREEN)Changed$(COLOR_RESET)  ] $$url: $$cur_ver -> $$new_ver\n"
				sed -i -e "/.*source\s\?=.*$$module.*/s|?ref=v\?[a-zA-Z0-9\.\-]\+|?ref=v$$new_ver|" main.tf
			else
				printf "\r[ Unchanged ] $$url: $$cur_ver\n"
			fi
		done
	fi

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

release-patch: import modules fmt update-version-patch
	$(MAKE) build-release

update-version-patch:
	@awk -F. -v OFS=. '{$$NF++;print}' $(VERSION_TXT) > $(VERSION_TXT).tmp
	mv -f  $(VERSION_TXT).tmp $(VERSION_TXT)
	echo "Auto-incremented version $(FILE_VERSION) -> $$(<$(VERSION_TXT))"


build-release:
	git pull --tags
	git commit -m "Built release $(RELEASE)" $(VERSION_TXT)
	git tag $(RELEASE)
	git push --tags
	git push
