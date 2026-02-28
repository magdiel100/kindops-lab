# Configuração do cluster kind

Arquivo principal:
- `kind-config.yaml`: topologia do cluster local `kindops-lab`.
- Perfil atual: `1 control-plane + 1 worker` (otimizado para baixo recurso).

Uso:
```bash
kind create cluster --name kindops-lab --config infra/kind/kind-config.yaml
```

## Limites de CPU/RAM dos nós
O script `scripts/bootstrap-kind.sh` aplica limites de cgroup nos containers dos nós do kind.

Valores padrão:
- control-plane: `1.0 CPU` e `1536m` de memória
- worker: `1.0 CPU` e `2048m` de memória

Para customizar:
```bash
CONTROL_PLANE_CPUS=0.8 \
CONTROL_PLANE_MEMORY=1200m \
WORKER_CPUS=1.2 \
WORKER_MEMORY=2200m \
./scripts/bootstrap-kind.sh
```
