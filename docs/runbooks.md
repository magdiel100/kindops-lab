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
  - Criar cluster kind.
  - Aplicar bootstrap de namespaces e addons.
  - Instalar Argo CD e stack observability.
- Validação:
  - Cluster `Ready`.
  - Pods principais `Running`.
  - Argo CD acessível.
- Rollback:
  - Remover cluster e recriar do zero.

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

