.PHONY: run load diagrams

run:
	bash ./iac/run.sh

test:
	bash ./iac/test.sh

diagrams:
	bash ./doc/diagrams/draw.sh

