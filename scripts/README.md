# Scripts operacionais da Fase 1

- `bootstrap-kind.sh`: valida ferramentas, cria cluster, namespaces base e instala ingress-nginx.
- `destroy-kind.sh`: remove o cluster `kindops-lab`.
- `recreate-kind.sh`: destrói e recria o cluster.

O `bootstrap-kind.sh` aplica limites de CPU/RAM nos nós do kind (perfil low-resource).
Variáveis opcionais:
- `CONTROL_PLANE_CPUS` (default: `1.0`)
- `CONTROL_PLANE_MEMORY` (default: `1536m`)
- `WORKER_CPUS` (default: `1.0`)
- `WORKER_MEMORY` (default: `2048m`)

Execução:
```bash
./scripts/bootstrap-kind.sh
./scripts/destroy-kind.sh
./scripts/recreate-kind.sh
```
