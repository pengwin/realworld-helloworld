.PHONY: build apply load diagrams helm-install

build:
	bash ./iac/build.sh

apply: build
	bash ./iac/apply.sh

helm-install:
	bash ./iac/helm-install.sh

test:
	bash ./iac/test.sh

diagrams:
	bash ./doc/diagrams/draw.sh

