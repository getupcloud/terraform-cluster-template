test: setup fmt init validate clean

i init:
	terraform init

v validate:
	terraform validate

f fmt:
	terraform fmt

setup:
	[ -d tests ] && for i in tests/*; do ln -vfs $$i; done || true

clean:
	[ -d tests ] && for i in tests/*; do rm -v $${i#tests/}; done || true
