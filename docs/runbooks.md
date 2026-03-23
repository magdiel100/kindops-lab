# Runbooks - kindops-lab

## Objetivo
Documentar procedimentos operacionais e resposta a incidentes de forma executavel.

## Padrão de runbook
### Nome
- Escopo:
- Pre-requisitos:
- Sinais de acionamento:
- Passo a passo:
- Validação:
- Rollback:
- Escalonamento:
- Pos-incidente:

## RB-001 - Bootstrap do laboratório
- Escopo: Subir ambiente base no kind.
- Pre-requisitos: Docker, kubectl, kind, helm, terraform, ansible.
- Passo a passo:
  - Executar bootstrap de host:
    - `make ansible-bootstrap`
  - Executar bootstrap do cluster:
    - `make bootstrap-kind`
  - O script realiza:
    - criação do cluster `kindops-lab` com config versionada (`infra/kind/kind-config.yaml`)
    - criação dos namespaces `cicd`, `argocd`, `observability`, `istio-system`, `apps`
    - instalação do `ingress-nginx` via Helm
- Validação:
  - `make phase1-check`
  - Cluster `Ready`.
  - Pods principais `Running`.
  - `kubectl get ns` com namespaces base criados.
  - `kubectl -n ingress-nginx get pods` com pods `Running`.
- Rollback:
  - `make destroy-kind`
  - `make recreate-kind`

## RB-002 - Deploy de aplicação via GitOps
- Escopo: Publicar nova versão de `app-python` ou `app-java`.
- Sinais de acionamento: Merge em `main`.
- Passo a passo:
  - Confirmar pipeline Jenkins verde.
  - Confirmar tag de imagem atualizada no repo GitOps.
  - Verificar sync no Argo CD.
- Validação:
  - Deploy `Healthy`.
  - Endpoint respondendo.
- Rollback:
  - Reverter commit no GitOps.

## RB-003 - Canary + auto rollback por métrica
- Escopo: Liberação progressiva com Argo Rollouts.
- Sinais de acionamento: Nova release.
- Passo a passo:
  - Iniciar canary.
  - Validar `AnalysisTemplate` (erro/latência).
  - Monitorar promoção automática.
- Validação:
  - Sem degradação de SLI.
- Rollback:
  - Auto rollback por threshold.
  - Fallback manual via rollback do Rollout.

## RB-004 - Incidente: alta taxa de erro
- Sinais de acionamento: alerta de erro alto.
- Passo a passo:
  - Verificar dashboard de erro no Grafana.
  - Correlacionar logs (Loki) e traces (Tempo).
  - Confirmar se houve deploy recente.
  - Acionar rollback se necessário.
- Validação:
  - Taxa de erro volta ao normal.
- Pos-incidente:
  - Registrar causa raiz e ação preventiva.

## RB-005 - Incidente: latência alta
- Sinais de acionamento: alerta de p95/p99 alto.
- Passo a passo:
  - Verificar métricas no Prometheus/Grafana.
  - Correlacionar com traces no Tempo.
  - Verificar saturação de recursos.
  - Ajustar limites/réplicas ou rollback.
- Validação:
  - p95/p99 normalizados.

## RB-006 - Incidente: fila acumulando (SQS)
- Sinais de acionamento: backlog crescente.
- Passo a passo:
  - Verificar taxa de consumo do worker.
  - Checar erros de processamento.
  - Escalar workers temporariamente.
- Validação:
  - Backlog reduzindo continuamente.

## RB-007 - FinOps: análise de custo com OpenCost
- Escopo: Revisão semanal de custo.
- Passo a passo:
  - Abrir dashboard FinOps.
  - Identificar top namespaces/workloads por custo.
  - Verificar anomalias de tendência.
  - Propor ação de otimização.
- Validação:
  - Plano de ação documentado.

## RB-008 - Chaos engineering com LitmusChaos
- Escopo: Validar resiliência com caos controlado.
- Experimentos:
  - pod-delete
  - cpu-hog
  - network-latency
- Passo a passo:
  - Executar experimento em janela controlada.
  - Monitorar SLI/SLO e alertas.
  - Validar comportamento de auto healing/rollback.
- Validação:
  - Impacto dentro do esperado.
  - Aprendizados registrados.

## Contatos e escalonamento
- Owner do projeto:
- Canal de incidente:
- Janela de manutenção:

## RB-009 - CI com Jenkins (Fase 2)
- Escopo: Instalar Jenkins no kind e executar pipelines declarativas de `app-python` e `app-java`.
- Pre-requisitos:
  - Cluster `kindops-lab` ativo.
  - Contexto kubectl: `kind-kindops-lab`.
  - Docker, kubectl, helm e kind instalados.
- Passo a passo:
  - Instalar Jenkins:
    - `make install-jenkins`
  - Expor a UI local:
    - `make jenkins-port-forward` (porta default local: `18080`)
  - Obter senha admin (se necessario, quando nao alterada manualmente):
    - `kubectl -n cicd get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d && echo`
  - Configurar credenciais de registry local no Jenkins:
    - ID: `registry-creds`
    - Tipo: Username with password
    - Uso nesta fase: validar `docker login` + `docker push` em ambiente local, sem depender da AWS.
  - Criar pipelines:
    - Job 1 apontando para `apps/app-python/Jenkinsfile`
    - Job 2 apontando para `apps/app-java/Jenkinsfile`
  - Definir `REGISTRY_HOST` como variavel de ambiente no job.
    - Exemplo para laboratorio local com Jenkins no kind: `host.docker.internal:5000`
  - Definir `REGISTRY_AUTH_REQUIRED` como variavel de ambiente no job.
    - Valor para Fase 2 com registry local sem auth: `false`
- Validacao:
  - `kubectl -n cicd get pods` com controller `Running`.
  - Stages dos Jenkinsfiles executando: lint, unit, integration, build, scan-trivy, smoke-k6, push.
- Evolucao planejada:
  - Migrar o push de imagens para ECR na Fase 8, com autenticacao AWS e consumo das imagens pelo kind.
- Rollback:
  - `helm -n cicd uninstall jenkins`
  - `kubectl delete ns cicd` (opcional, se quiser reset total da fase)

## RB-010 - Evolucao Fase 2: agentes dinamicos Kubernetes no Jenkins
- Escopo: mover execucao de pipeline do controller para pods efemeros no namespace `cicd`.
- Pre-requisitos:
  - Plugin `kubernetes` instalado no Jenkins.
  - ServiceAccount `jenkins` com permissao para criar/listar/deletar pods em `cicd`.
  - Imagem de agente CI publicada em `localhost:5000/jenkins-agent-ci:latest`.
- Passo a passo:
  - Build/push da imagem base do agente:
    - `docker build -t localhost:5000/jenkins-agent-ci:latest -f infra/jenkins/agent/Dockerfile .`
    - `docker push localhost:5000/jenkins-agent-ci:latest`
  - Carregar imagem do agent nos nodes kind (mitigacao para pull HTTP/TLS):
    - `docker tag localhost:5000/jenkins-agent-ci:latest jenkins-agent-ci:local`
    - `kind load docker-image jenkins-agent-ci:local --name kindops-lab`
  - Configurar cloud Kubernetes no Jenkins:
    - `Manage Jenkins > Clouds > New cloud > Kubernetes`
    - Namespace: `cicd`
    - Jenkins URL interno: `http://jenkins.cicd.svc.cluster.local:8080`
    - Jenkins tunnel: `jenkins-agent.cicd.svc.cluster.local:50000` (quando aplicavel)
    - Test Connection deve retornar sucesso.
  - Atualizar jobs para usar os Jenkinsfiles versionados:
    - `apps/app-python/Jenkinsfile`
    - `apps/app-java/Jenkinsfile`
  - Executar build e validar pod efemero:
    - `kubectl -n cicd get pods -w`
    - conferir pod `jenkins-agent-*` criado durante execucao.
- Validacao:
  - Build nao fica em `Waiting for next available executor`.
  - Stage `lint` de `app-python` encontra `python3`.
  - Console mostra `Running on ... in /home/jenkins/agent/workspace/...`.
- Troubleshooting:
  - `403` ao criar pod:
    - Validar RBAC do ServiceAccount `jenkins` em `cicd`.
  - `ImagePullBackOff`:
    - Confirmar push da imagem para `localhost:5000`.
    - Se houver erro `HTTP response to HTTPS client`, usar `kind load` e imagem local (`jenkins-agent-ci:local`).
    - Testar pull/execucao da imagem por pod de diagnostico no namespace `cicd`.
  - `Cannot connect to the Docker daemon`:
    - Confirmar mount de `/var/run/docker.sock` no podTemplate.
  - Pod termina por `OOMKilled`/timeout:
    - Ajustar `resources.requests/limits` no podTemplate dos Jenkinsfiles.
  - `StartError` com `cpu.cfs_quota_us: invalid argument` no container `ci`:
    - Revisar `limits.cpu` do podTemplate do agente.
    - No ambiente kind local, remover `limits.cpu` quando houver incompatibilidade de cgroup/runtime.
    - Reexecutar e validar criacao do pod `jenkins-agent-*` em `Running`.
  - `requirements-dev.txt` (ou `pom.xml`) nao encontrado no stage:
    - Confirmar que o pipeline executa no subdiretorio da app (`apps/app-python` ou `apps/app-java`).
    - Usar `dir("${APP_DIR}")` nos stages para garantir contexto correto de workspace.
  - `ModuleNotFoundError: No module named 'app'` no pytest da app Python:
    - Executar testes com `PYTHONPATH=.`
    - Exemplo:
      - `PYTHONPATH=. pytest -q tests/test_unit_health.py`
      - `PYTHONPATH=. pytest -q tests/test_integration_http.py`
  - `permission denied` no `docker build` com `/var/run/docker.sock` montado:
    - Ajustar `securityContext` do container `ci` no podTemplate para:
      - `runAsUser: 0`
      - `runAsGroup: 0`
    - Reexecutar job e validar acesso ao daemon Docker.
  - Pod nao sobe por erro de cloud:
    - Revalidar endpoint/namespace da cloud Kubernetes em `Manage Jenkins > Clouds`.
  - `jenkins-0` em `Init:1/2` ou `CrashLoopBackOff` apos upgrade:
    - Verificar estado do release: `helm status jenkins -n cicd` e `helm history jenkins -n cicd`.
    - Coletar erro do init: `kubectl -n cicd logs jenkins-0 -c init --previous --tail=220`.
    - Se houver conflito de dependencia de plugin (ex.: `git` x `eddsa-api`), retornar para revisao estavel:
      - `helm rollback jenkins 11 -n cicd --wait --timeout 10m`
    - Confirmar recuperacao:
      - `kubectl -n cicd get pods -o wide`
      - `kubectl -n cicd rollout status statefulset/jenkins --timeout=120s`
- Rollback:
  - Voltar temporariamente para `agent any` no Jenkinsfile.
  - Reexecutar job para restaurar fluxo no controller enquanto corrige configuracao da cloud.

### Consulta rapida do registry local (apoio operacional)
- Listar repositorios:
  - `curl -s http://localhost:5000/v2/_catalog`
- Listar tags de um repositorio:
  - `curl -s http://localhost:5000/v2/<repo>/tags/list`
- Listar `repo:tag` com tamanho em bytes/MB:
  - usar funcao `regsizes` documentada no `docs/knowledge.md`.
