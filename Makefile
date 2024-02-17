.PHONY: build apply load diagrams

build:
	bash ./iac/build.sh

apply: build
	bash ./iac/apply.sh

test:
	bash ./iac/test.sh

diagrams:
	bash ./doc/diagrams/draw.sh

