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
