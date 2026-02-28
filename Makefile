.PHONY: bootstrap tree ansible-bootstrap bootstrap-kind destroy-kind recreate-kind phase1-check

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

ansible-bootstrap:
	@cd infra/ansible && ANSIBLE_ROLES_PATH=roles ansible-playbook -i inventory/hosts.ini -e @group_vars/all.yml playbooks/bootstrap-host.yml

bootstrap-kind:
	@./scripts/bootstrap-kind.sh

destroy-kind:
	@./scripts/destroy-kind.sh

recreate-kind:
	@./scripts/recreate-kind.sh

phase1-check:
	@bash -n scripts/bootstrap-kind.sh scripts/destroy-kind.sh scripts/recreate-kind.sh
	@echo "Scripts shell validados."
