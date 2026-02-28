# kindops-lab

Laboratório prático para aprender DevOps/SRE com foco em implementação real, documentação e evolução incremental.

## Pre-requisitos
- Git
- Docker
- kubectl
- kind
- Helm
- Terraform
- Ansible
- Make

## Estrutura do projeto
- `apps/`
- `infra/terraform/`
- `infra/ansible/`
- `charts/`
- `gitops/`
- `observability/`
- `docs/`

## Início rápido
```bash
make bootstrap
```

## Fase 1 - Bootstrap local
```bash
# 1) Bootstrap do host (Linux/WSL)
make ansible-bootstrap

# 2) Subir cluster kind + namespaces + ingress
make bootstrap-kind

# 3) Recriar cluster do zero (teste de reprodutibilidade)
make recreate-kind
```

## Contribuição
Leia `docs/CONTRIBUTING.md` para convenções de branch, fluxo de PR e checklist.
