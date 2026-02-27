.PHONY: bootstrap tree

bootstrap:
	@mkdir -p apps
	@mkdir -p infra/terraform
	@mkdir -p infra/ansible
	@mkdir -p charts
	@mkdir -p gitops
	@mkdir -p observability
	@mkdir -p docs
	@mkdir -p .github/ISSUE_TEMPLATE
	@echo "Bootstrap concluido."

tree:
	@find . -maxdepth 2 -type d | sort
