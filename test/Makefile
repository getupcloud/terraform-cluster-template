all: test

test: .terraform/modules/modules.json
	terraform validate
	terraform plan

.terraform/modules/modules.json: main.tf
	terraform init

clean:
	rm -rf ./.terraform ./.terraform.lock.hcl
