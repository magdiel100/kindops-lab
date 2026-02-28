# Ansible bootstrap do host

Este diretório contém o bootstrap do host local (Linux/WSL) para o laboratório.

## Estrutura
- `inventory/hosts.ini`: inventário local.
- `group_vars/all.yml`: variáveis e versões das ferramentas.
- `playbooks/bootstrap-host.yml`: playbook principal.
- `roles/*`: roles por ferramenta.

## Execução
```bash
cd infra/ansible
ansible-playbook playbooks/bootstrap-host.yml
```

## Observação
Se Docker, kubectl, kind ou Helm já estiverem instalados, as roles apenas registram aviso e seguem sem reinstalar.
