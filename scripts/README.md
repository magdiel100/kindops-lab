# Scripts operacionais

## Fase 1
- `bootstrap-kind.sh`: valida ferramentas, cria cluster, namespaces base e instala ingress-nginx.
- `destroy-kind.sh`: remove o cluster `kindops-lab`.
- `recreate-kind.sh`: destroi e recria o cluster, exporta kubeconfig e define contexto kubectl.

Variaveis opcionais do `bootstrap-kind.sh`:
- `CONTROL_PLANE_CPUS` (default: `1.0`)
- `CONTROL_PLANE_MEMORY` (default: `1536m`)
- `WORKER_CPUS` (default: `1.0`)
- `WORKER_MEMORY` (default: `2048m`)

Execucao:
```bash
./scripts/bootstrap-kind.sh
./scripts/destroy-kind.sh
./scripts/recreate-kind.sh
```

## Fase 2
- `install-jenkins.sh`: instala/atualiza Jenkins via Helm no namespace `cicd`.
- `jenkins-port-forward.sh`: publica a UI do Jenkins em `http://127.0.0.1:18080` (default).

Execucao:
```bash
./scripts/install-jenkins.sh
./scripts/jenkins-port-forward.sh
```
