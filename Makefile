init:
	terraform init

plan:
	terraform plan

apply:
	terraform apply

clean:
	rm -rf .terraform*

reset:
	terraform state list \
	| grep aws_sfn_state_machine \
	| tac \
	| xargs -n1 terraform apply -auto-approve -replace

.PHONY: init plan apply clean reset
