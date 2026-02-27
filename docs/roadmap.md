# Roadmap: SRE/DevOps Lab com kind

## Visao geral
Projeto pessoal para praticar CI/CD, GitOps, IaC, observabilidade e operacao SRE em ambiente local com Kubernetes kind.

Aplicacoes alvo:
- `app-python` (FastAPI + worker)
- `app-java` (Spring Boot)

Duracao sugerida: 16 a 18 semanas (ajustavel).

## Fase 0 - Fundacao e padroes (Semana 1)
Objetivo:
- Preparar estrutura do projeto, padroes de codigo e base de documentacao.

Entregaveis:
- Repositorio criado com estrutura:
  - `apps/`
  - `infra/terraform/`
  - `infra/ansible/`
  - `charts/`
  - `gitops/`
  - `observability/`
  - `docs/`
- Convencoes de branch e PR definidas.
- Templates de issue/PR e checklist de qualidade.

Criterios de pronto:
- Projeto inicia com um comando documentado (`make bootstrap` ou script equivalente).
- README com pre-requisitos e fluxo de contribuicao.

## Fase 1 - Bootstrap local (Semanas 1-2)
Objetivo:
- Subir o laboratorio local com kind e dependencias base.

Entregaveis:
- Ansible para configurar host (docker, kubectl, kind, helm).
- Cluster kind criado com configuracao versionada.
- Namespaces base: `cicd`, `argocd`, `observability`, `istio-system`, `apps`.
- Ingress controller instalado.

Criterios de pronto:
- Cluster sobe de forma reproduzivel.
- Script de destroy/recreate documentado.

## Fase 2 - CI com Jenkins (Semanas 2-4)
Objetivo:
- Criar pipeline de integracao continua robusta.

Entregaveis:
- Jenkins instalado no cluster (Helm).
- Pipelines declarativas para `app-python` e `app-java` com estagios:
  - lint
  - teste unitario
  - teste de integracao
  - build imagem
  - scan (Trivy)
  - smoke test de carga (K6)
  - push para registry
- Dockerfiles de `app-python` e `app-java` com:
  - multi-stage builds
  - `HEALTHCHECK`
  - camadas otimizadas para cache e tamanho final
- Badges e status checks no GitHub.

Criterios de pronto:
- PR bloqueado sem passar pipeline.
- Build reproduzivel por tag e commit SHA.
- Imagens finais menores e com tempo de build reduzido apos otimizacao de camadas.

## Fase 3 - CD GitOps com Argo CD (Semanas 4-5)
Objetivo:
- Automatizar deploy usando estado desejado em Git.

Entregaveis:
- Argo CD instalado e acessivel.
- Apps Helm registradas via `Application`/`ApplicationSet`:
  - `app-python`
  - `app-java`
- Estrategia de valores por ambiente (`dev-local`, `staging-local` opcional).
- Rollback via `git revert`.
- Subtopico ArgoCD: canary deployment com Argo Rollouts.
- `AnalysisTemplate` ligado ao Prometheus para validacao por metrica.
- Auto rollback quando latencia/erros ultrapassarem thresholds definidos.

Criterios de pronto:
- Merge em `main` gera deploy automatico no kind.
- Drift detectado e corrigido pelo Argo CD.
- Canary executado com promocao automatica quando metricas estiverem saudaveis.
- Rollback automatico comprovado por falha controlada de metrica.

## Fase 4 - Infra as Code com Terraform (Semanas 5-6)
Objetivo:
- Padronizar provisionamento de componentes Kubernetes por codigo.

Entregaveis:
- Terraform para addons base:
  - namespaces
  - service accounts e RBAC
  - configuracoes de observabilidade
  - recursos de suporte para apps
- States e variaveis organizados.

Criterios de pronto:
- `terraform plan/apply` com output limpo e previsivel.
- Recursos criticos sem configuracao manual ad-hoc.

## Fase 5 - OpenTelemetry end-to-end (Semanas 6-8)
Objetivo:
- Instrumentar aplicacao e coletar traces, metricas e logs com OpenTelemetry usando backend self-hosted no kind.

Entregaveis:
- Instrumentacao OTel em `app-python`, `app-python-worker` e `app-java`:
  - spans de entrada/saida HTTP
  - spans de processamento assicrono
  - propagacao de contexto entre componentes
- OTel Collector implantado com pipelines:
  - receiver OTLP (gRPC/HTTP)
  - processors (`batch`, `memory_limiter`, `resource`)
  - exporters para stack observability local (Prometheus, Loki e Tempo)
- Correlacao logs x traces com `trace_id` e `span_id`.

Criterios de pronto:
- Traces distribuidos visiveis por transacao completa.
- Dashboard com p50/p95/p99, erro e throughput.
- Cobertura de telemetria em rotas principais > 90% nas duas apps.
- Telemetria funcionando fim a fim apenas com componentes self-hosted no kind.

## Fase 6 - Observabilidade e operacao (Semanas 8-9)
Objetivo:
- Tornar o ambiente observavel e acionavel.

Entregaveis:
- Observabilidade operacional ativa no kind com configuracao manual de:
  - Prometheus (scrape jobs, relabeling, retention)
  - Grafana (datasources, dashboards, pastas e provisionamento)
  - Loki (pipeline de logs e labels)
  - Tempo (armazenamento e consulta de traces)
  - OTel Collector (pipelines e roteamento por sinal)
  - OpenCost (alocacao de custos por namespace/workload/label)
- Dashboards:
  - visao executiva (SLO)
  - visao tecnica (infra + aplicacao)
  - visao FinOps (custo por servico e tendencia semanal)
- Regras de alerta:
  - erro alto
  - latencia alta
  - fila acumulando
  - restart em loop

Criterios de pronto:
- Alertas acionam com testes controlados.
- Runbooks vinculados a cada alerta critico.
- OpenCost operando com relatórios de custo por namespace e workload.

## Fase 7 - Service Mesh com Istio (Semanas 9-10)
Objetivo:
- Controlar trafego, seguranca e resiliencia entre microservicos com service mesh.

Entregaveis:
- Istio instalado com profile `demo` ou `default` otimizado para kind.
- Sidecar injection habilitada no namespace `apps`.
- mTLS em modo strict para comunicacao interna.
- Politicas:
  - `PeerAuthentication`
  - `RequestAuthentication`
  - `AuthorizationPolicy`
- Roteamento progressivo:
  - `VirtualService` + `DestinationRule`
  - canary inicial (exemplo: 90/10)

Criterios de pronto:
- Servicos comunicando somente via mesh.
- Canary executado com rollback por configuracao GitOps.
- Metricas do Istio exportadas pelo OTel e visiveis no Prometheus/Grafana self-hosted.

## Fase 8 - Integracoes AWS low-cost (Semanas 10-11)
Objetivo:
- Integrar o laboratorio local com servicos AWS de baixo custo/free tier.

Entregaveis:
- ECR para armazenar imagens do pipeline Jenkins.
- SQS para fluxo assicrono real da aplicacao.
- DynamoDB (on-demand) para estado leve/deduplicacao.
- Lambda para automacao event-driven simples.
- Terraform com modulos para os recursos AWS usados.
- AWS Budgets com alertas de custo baixo (ex: USD 5 e USD 10).

Criterios de pronto:
- Deploy no kind consumindo imagem do ECR.
- Aplicacao processando mensagens reais do SQS.
- Custos mensais dentro do limite definido no projeto.

## Fase 9 - Performance e carga com K6 (Semanas 11-12)
Objetivo:
- Validar comportamento da plataforma sob carga com cenarios reproduziveis.

Entregaveis:
- Suite de testes K6 versionada:
  - `smoke`
  - `load`
  - `stress`
- Cenarios dedicados para `app-python` e `app-java` para comparativo de performance.
- Thresholds definidos (latencia e taxa de erro).
- Exportacao de metricas do K6 via OTel para Prometheus/Grafana self-hosted.
- Job agendado de baseline semanal de performance.

Criterios de pronto:
- Relatorio de carga gerado automaticamente no pipeline.
- Regressao de performance detectada por threshold no CI.
- Comparativo baseline Python vs Java registrado na documentacao.

## Fase 10 - Confiabilidade SRE (Semanas 12-14)
Objetivo:
- Introduzir disciplina de SLI/SLO e resposta a incidentes.

Entregaveis:
- Definicao de SLIs:
  - disponibilidade
  - latencia
  - taxa de erro
- SLOs mensais definidos e medidos.
- Error budget e politica de congelamento de mudancas.
- Game days (falhas simuladas) e postmortems.
- LitmusChaos instalado e configurado com experimentos iniciais:
  - pod-delete
  - network-latency
  - cpu-hog
- Relatorios de resiliencia conectando experimento, impacto em SLI e acao corretiva.

Criterios de pronto:
- 2 ou mais incidentes simulados com aprendizado registrado.
- Decisoes orientadas por SLO em pelo menos 1 ciclo de entrega.
- Pelo menos 3 experimentos LitmusChaos executados com rollback validado.

## Fase 11 - Seguranca e governanca (Semanas 14-15)
Objetivo:
- Aplicar seguranca de supply chain e politicas de cluster.

Entregaveis:
- Kyverno com politicas basicas:
  - bloquear `latest`
  - exigir requests/limits
  - exigir probes
- Scan continuo de imagens/dependencias.
- Gestao de segredos com Sealed Secrets ou SOPS.

Criterios de pronto:
- Politicas impedem deploys fora do padrao.
- Segredos fora do repositorio em texto puro.

## Fase 12 - Fechamento de portfolio (Semanas 15-17)
Objetivo:
- Consolidar projeto para demonstracao profissional.

Entregaveis:
- Documentacao final:
  - arquitetura
  - roadmap executado
  - runbooks
  - postmortems
- Demo guiada com cenario de incidente e recuperacao.
- Backlog de melhorias futuras.

Criterios de pronto:
- Qualquer pessoa consegue subir ambiente seguindo docs.
- Projeto demonstravel em 15-20 minutos.

## Fase 13 - IA aplicada a observabilidade (Semanas 17-18)
Objetivo:
- Aumentar capacidade de investigacao com recursos de IA no Grafana sobre dados de metricas, logs e traces.

Entregaveis:
- Plugins/recursos de IA no Grafana configurados para assistencia de troubleshooting.
- Fluxo de correlacao com IA usando:
  - Prometheus (metricas)
  - Loki (logs)
  - Tempo (traces)
- Playbook de analise assistida por IA para incidentes comuns.
- Validacao com 2 cenarios reais de troubleshooting (erro alto e latencia alta).

Criterios de pronto:
- IA retorna hipoteses e links de correlacao entre metricas, logs e traces.
- Tempo medio de diagnostico reduzido nos cenarios validados.
- Limitacoes e riscos de uso de IA documentados (falsos positivos, privacidade, dependencia de contexto).

## KPIs de sucesso do projeto
- Lead time de mudanca reduzido ao longo das fases.
- Taxa de falha de deploy em queda.
- MTTR melhorando nos game days.
- Cobertura de telemetria e alertas aumentando por release.

## Proximos incrementos (opcional)
- Progressive delivery (Argo Rollouts).
- Multi-cluster e promocao entre ambientes.
