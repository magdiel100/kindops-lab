# Roadmap: SRE/DevOps Lab com kind

## VisÃ£o geral
Projeto prÃ¡tico de Platform Engineering/DevOps/SRE para construir, operar e evoluir uma plataforma cloud-native local em Kubernetes kind, com foco em aprendizado aplicado e documentado.

Escopo tÃ©cnico coberto:
- Entrega de software: CI com Jenkins, CD GitOps com Argo CD e estratÃ©gias de canary + auto rollback por mÃ©trica.
- Infraestrutura como cÃ³digo: provisionamento e padronizaÃ§Ã£o com Terraform e Ansible.
- Observabilidade end-to-end: OpenTelemetry + Prometheus + Grafana + Loki + Tempo (self-hosted no kind).
- Confiabilidade e resiliÃªncia: SLI/SLO, runbooks, game days e chaos engineering com LitmusChaos.
- Performance e capacidade: testes de carga com K6 e comparativo Python vs Java.
- FinOps: visibilidade de custo por namespace/workload com OpenCost.
- IntegraÃ§Ã£o cloud low-cost: ECR, SQS, DynamoDB, Lambda e Budgets na AWS.
- EvoluÃ§Ã£o assistida por IA: investigaÃ§Ã£o de incidentes no Grafana com correlaÃ§Ã£o entre mÃ©tricas, logs e traces.

Resultado esperado:
- Pipeline ponta a ponta reproduzÃ­vel, com operaÃ§Ã£o orientada por mÃ©tricas e documentaÃ§Ã£o de conhecimento para retomada rÃ¡pida.

AplicaÃ§Ãµes alvo:
- `app-python` (FastAPI + worker)
- `app-java` (Spring Boot)

DuraÃ§Ã£o sugerida: 16 a 18 semanas (ajustÃ¡vel).

## Status atual
- Fase 0: concluÃ­da.
- Fase 1: concluÃ­da.
- Fase 2: concluÃ­da.
- PrÃ³xima fase: Fase 3 (CD GitOps com Argo CD).

## Fase 0 - FundaÃ§Ã£o e padrÃµes (Semana 1)
Objetivo:
- Preparar estrutura do projeto, padrÃµes de cÃ³digo e base de documentaÃ§Ã£o.

EntregÃ¡veis:
- RepositÃ³rio criado com estrutura:
  - `apps/`
  - `infra/terraform/`
  - `infra/ansible/`
  - `charts/`
  - `gitops/`
  - `observability/`
  - `docs/`
- ConvenÃ§Ãµes de branch e PR definidas.
- Templates de issue/PR e checklist de qualidade.

CritÃ©rios de pronto:
- Projeto inicia com um comando documentado (`make bootstrap` ou script equivalente).
- README com pre-requisitos e fluxo de contribuiÃ§Ã£o.

Checklist operacional (drill-down):
- [x] Validar estrutura mÃ­nima de pastas do repositÃ³rio.
- [x] Criar/atualizar `README.md` com pre-requisitos e fluxo inicial.
- [x] Criar/atualizar `docs/CONTRIBUTING.md` com padrÃµes de branch e PR.
- [x] Criar templates em `.github` para PR e Issues.
- [x] Criar `Makefile` com alvo `bootstrap` (ou script equivalente).
- [x] Validar `.gitignore` com itens de Terraform e ambiente local.
- [x] Registrar Fase 0 em `docs/knowledge.md`.
- [x] Publicar base inicial no GitHub (main sincronizada com origin/main).

Data de execuÃ§Ã£o da Fase 0: 2026-02-27

## Fase 1 - Bootstrap local (Semanas 1-2)
Objetivo:
- Subir o laboratÃ³rio local com kind e dependÃªncias base.

EntregÃ¡veis:
- Ansible para configurar host (docker, kubectl, kind, helm).
- Cluster kind criado com configuraÃ§Ã£o versionada.
- Namespaces base: `cicd`, `argocd`, `observability`, `istio-system`, `apps`.
- Ingress controller instalado.

CritÃ©rios de pronto:
- Cluster sobe de forma reproduzÃ­vel.
- Script de destroy/recreate documentado.

Checklist operacional (drill-down):
- [x] Criar estrutura inicial em `infra/ansible/` para bootstrap do host.
- [x] Definir variÃ¡veis e inventario do Ansible para ambiente local.
- [x] Criar playbook para instalar Docker.
- [x] Criar playbook para instalar `kubectl`.
- [x] Criar playbook para instalar `kind`.
- [x] Criar playbook para instalar `helm`.
- [x] Validar versÃµes instaladas (`docker`, `kubectl`, `kind`, `helm`).
- [x] Criar arquivo de configuraÃ§Ã£o versionado do cluster kind.
- [x] Subir cluster kind com comando documentado.
- [x] Verificar estado do cluster (`kubectl get nodes`).
- [x] Criar namespaces `cicd`, `argocd`, `observability`, `istio-system`, `apps`.
- [x] Validar namespaces criados com `kubectl get ns`.
- [x] Instalar ingress controller no cluster.
- [x] Validar ingress controller com pods `Running`.
- [x] Criar script de `destroy` do cluster.
- [x] Criar script de `recreate` (destroy + create).
- [x] Documentar passos de bootstrap no `runbooks.md`.
- [x] Registrar aprendizados e evidÃªncias da fase no `knowledge.md`.
- [x] Executar teste de reproducibilidade: destruir e recriar cluster do zero.

Nota operacional (WSL + `/mnt/c`):
- Ao executar Ansible em diretÃ³rio world-writable, `ansible.cfg` pode ser ignorado.
- Fluxo suportado no projeto: `make ansible-bootstrap` com inventÃ¡rio/vars/roles definidos explicitamente no comando.
- Para este laboratÃ³rio, Docker serÃ¡ provido por Docker Desktop (`install_docker: false`), sem instalar `docker.io` via Ansible.

Data de execuÃ§Ã£o da Fase 1: 2026-02-28

## Fase 2 - CI com Jenkins (Semanas 2-4)
Objetivo:
- Criar pipeline de integraÃ§Ã£o continua robusta.

EntregÃ¡veis:
- Jenkins instalado no cluster (Helm).
- Pipelines declarativas para `app-python` e `app-java` com estÃ¡gios:
  - lint
  - teste unitÃ¡rio
  - teste de integraÃ§Ã£o
  - build imagem
  - scan (Trivy)
  - smoke test de carga (K6)
  - push para registry
- Dockerfiles de `app-python` e `app-java` com:
  - multi-stage builds
  - `HEALTHCHECK`
  - camadas otimizadas para cache e tamanho final
- Badges e status checks no GitHub.

CritÃ©rios de pronto:
- PR bloqueado sem passar pipeline.
- Build reproduzÃ­vel por tag e commit SHA.
- Imagens finais menores e com tempo de build reduzido apÃ³s otimizaÃ§Ã£o de camadas.

Checklist operacional (drill-down):
- [x] Instalar Jenkins via Helm no namespace `cicd`.
- [x] Configurar integração com registry local no Jenkins (host acessível pelo kind + modo sem autenticação).
- [x] Criar pipeline declarativa para `app-python`.
- [x] Criar pipeline declarativa para `app-java`.
- [x] Incluir stages: lint, unit, integration, build, scan Trivy, smoke K6, push.
- [x] Validar Dockerfiles com multi-stage, `HEALTHCHECK` e cache de camadas.
- [x] Validar conectividade do cluster kind com registry local em `host.docker.internal:5000`.
- [x] Ajustar pipelines para push sem login quando `REGISTRY_AUTH_REQUIRED=false` (mantendo compatibilidade futura com `registry-creds`).
- [x] Executar pipeline end-to-end e capturar evidências.
- [x] Documentar fluxo CI no `runbooks.md` e aprendizados no `knowledge.md`.

Nota de evolução:
- Nesta fase, o objetivo é validar o CI com menor atrito usando registry local.
- A publicação em ECR fica planejada para a Fase 8, onde a integração AWS passa a fazer parte do escopo oficial do projeto.

Atualização operacional da Fase 2 (registry local):
- Finalidade: fechar a validação do CI na Fase 2 com menor acoplamento externo, sem bloquear evolução para ECR nas fases AWS.
- Ações executadas:
  - Registry local `registry-local` validado com API `v2` respondendo `HTTP 200`.
  - Conectividade validada a partir dos nós do kind para `host.docker.internal:5000`.
  - `Jenkinsfile` de `app-python` e `app-java` ajustados para tornar autenticação opcional via `REGISTRY_AUTH_REQUIRED`.
  - Execução end-to-end concluída para as duas apps (lint, unit, integration, build, smoke, push) com tag `b6150be`.
  - Correções aplicadas durante a execução:
    - `app-java`: ajuste de `@PathVariable("name")` para estabilizar teste de integração.
    - `app-java`: configuração de `repackage` no `spring-boot-maven-plugin` para gerar jar executável no container.
- Evidências capturadas:
  - Imagens locais/publicadas: `localhost:5000/app-python:b6150be` e `localhost:5000/app-java:b6150be`.
  - Catálogo do registry: `{"repositories":["app-java","app-python"]}`.
  - Tags no registry:
    - `{"name":"app-python","tags":["b6150be"]}`
    - `{"name":"app-java","tags":["b6150be"]}`
- Resultado esperado:
  - Fase 2 opera com push em registry interno local.
  - Migração para ECR permanece como incremento natural da Fase 8.

## Fase 3 - CD GitOps com Argo CD (Semanas 4-5)
Objetivo:
- Automatizar deploy usando estado desejado em Git.

EntregÃ¡veis:
- Argo CD instalado e acessÃ­vel.
- Apps Helm registradas via `Application`/`ApplicationSet`:
  - `app-python`
  - `app-java`
- EstratÃ©gia de valores por ambiente (`dev-local`, `staging-local` opcional).
- Rollback via `git revert`.
- Subtopico ArgoCD: canary deployment com Argo Rollouts.
- `AnalysisTemplate` ligado ao Prometheus para validaÃ§Ã£o por mÃ©trica.
- Auto rollback quando latÃªncia/erros ultrapassarem thresholds definidos.

CritÃ©rios de pronto:
- Merge em `main` gera deploy automÃ¡tico no kind.
- Drift detectado e corrigido pelo Argo CD.
- Canary executado com promoÃ§Ã£o automÃ¡tica quando mÃ©tricas estiverem saudaveis.
- Rollback automÃ¡tico comprovado por falha controlada de mÃ©trica.

Checklist operacional (drill-down):
- [ ] Instalar Argo CD no namespace `argocd`.
- [ ] Criar `Application`/`ApplicationSet` para `app-python`.
- [ ] Criar `Application`/`ApplicationSet` para `app-java`.
- [ ] Configurar sincronizaÃ§Ã£o automÃ¡tica e polÃ­tica de self-heal.
- [ ] Instalar/ativar Argo Rollouts para canary.
- [ ] Criar `AnalysisTemplate` com mÃ©tricas de erro e latÃªncia.
- [ ] Simular degradaÃ§Ã£o e validar auto rollback.
- [ ] Registrar fluxo GitOps e canary em `runbooks.md`.

## Fase 4 - Infra as Code com Terraform (Semanas 5-6)
Objetivo:
- Padronizar provisionamento de componentes Kubernetes por cÃ³digo.

EntregÃ¡veis:
- Terraform para addons base:
  - namespaces
  - service accounts e RBAC
  - configuraÃ§Ãµes de observabilidade
  - recursos de suporte para apps
- States e variÃ¡veis organizados.

CritÃ©rios de pronto:
- `terraform plan/apply` com output limpo e previsivel.
- Recursos crÃ­ticos sem configuraÃ§Ã£o manual ad-hoc.

Checklist operacional (drill-down):
- [ ] Definir providers e backend de state Terraform.
- [ ] Criar mÃ³dulo/base para namespaces e RBAC.
- [ ] Criar mÃ³dulo/base para recursos de observabilidade.
- [ ] Criar variÃ¡veis e `terraform.tfvars.example`.
- [ ] Executar `terraform fmt` e validaÃ§Ã£o.
- [ ] Executar `terraform plan` e revisar mudanÃ§as.
- [ ] Executar `terraform apply` em ambiente local.
- [ ] Documentar comandos e ordem de execuÃ§Ã£o no `runbooks.md`.

## Fase 5 - OpenTelemetry end-to-end (Semanas 6-8)
Objetivo:
- Instrumentar aplicaÃ§Ã£o e coletar traces, mÃ©tricas e logs com OpenTelemetry usando backend self-hosted no kind.

EntregÃ¡veis:
- Instrumentacao OTel em `app-python`, `app-python-worker` e `app-java`:
  - spans de entrada/saida HTTP
  - spans de processamento assÃ­ncrono
  - propagacao de contexto entre componentes
- OTel Collector implantado com pipelines:
  - receiver OTLP (gRPC/HTTP)
  - processors (`batch`, `memory_limiter`, `resource`)
  - exporters para stack observability local (Prometheus, Loki e Tempo)
- Correlacao logs x traces com `trace_id` e `span_id`.

CritÃ©rios de pronto:
- Traces distribuidos visiveis por transacao completa.
- Dashboard com p50/p95/p99, erro e throughput.
- Cobertura de telemetria em rotas principais > 90% nas duas apps.
- Telemetria funcionando fim a fim apenas com componentes self-hosted no kind.

Checklist operacional (drill-down):
- [ ] Instrumentar `app-python` com OTel (traces, metrics, logs).
- [ ] Instrumentar `app-java` com OTel (traces, metrics, logs).
- [ ] Instrumentar `app-python-worker` com propagacao de contexto.
- [ ] Implantar OTel Collector com pipelines OTLP.
- [ ] Configurar export para Prometheus, Loki e Tempo.
- [ ] Validar correlaÃ§Ã£o `trace_id` entre logs e traces.
- [ ] Criar dashboards iniciais de RED metrics.
- [ ] Registrar configuraÃ§Ã£o e troubleshooting no `knowledge.md`.

## Fase 6 - Observabilidade e operaÃ§Ã£o (Semanas 8-9)
Objetivo:
- Tornar o ambiente observavel e acionÃ¡vel.

EntregÃ¡veis:
- Observabilidade operacional ativa no kind com configuraÃ§Ã£o manual de:
  - Prometheus (scrape jobs, relabeling, retention)
  - Grafana (datasources, dashboards, pastas e provisionamento)
  - Loki (pipeline de logs e labels)
  - Tempo (armazenamento e consulta de traces)
  - OTel Collector (pipelines e roteamento por sinal)
  - OpenCost (alocaÃ§Ã£o de custos por namespace/workload/label)
- Dashboards:
  - visao executiva (SLO)
  - visao tÃ©cnica (infra + aplicaÃ§Ã£o)
  - visao FinOps (custo por serviÃ§o e tendÃªncia semanal)
- Regras de alerta:
  - erro alto
  - latÃªncia alta
  - fila acumulando
  - restart em loop

CritÃ©rios de pronto:
- Alertas acionam com testes controlados.
- Runbooks vinculados a cada alerta critico.
- OpenCost operando com relatÃ³rios de custo por namespace e workload.

Checklist operacional (drill-down):
- [ ] Instalar Prometheus com scrape jobs e retention definidos.
- [ ] Instalar Grafana com provisionamento de datasources.
- [ ] Instalar Loki e validar ingestao de logs.
- [ ] Instalar Tempo e validar consulta de traces.
- [ ] Integrar OTel Collector com toda stack observability.
- [ ] Instalar OpenCost e validar mÃ©tricas de custo.
- [ ] Criar dashboards: executivo, tÃ©cnico e FinOps.
- [ ] Criar alertas e vincular runbooks para cada alerta critico.

## Fase 7 - Service Mesh com Istio (Semanas 9-10)
Objetivo:
- Controlar trÃ¡fego, seguranÃ§a e resiliÃªncia entre microservicos com service mesh.

EntregÃ¡veis:
- Istio instalado com profile `demo` ou `default` otimizado para kind.
- Sidecar injection habilitada no namespace `apps`.
- mTLS em modo strict para comunicaÃ§Ã£o interna.
- PolÃ­ticas:
  - `PeerAuthentication`
  - `RequestAuthentication`
  - `AuthorizationPolicy`
- Roteamento progressivo:
  - `VirtualService` + `DestinationRule`
  - canary inicial (exemplo: 90/10)

CritÃ©rios de pronto:
- ServiÃ§os comunicando somente via mesh.
- Canary executado com rollback por configuraÃ§Ã£o GitOps.
- Metricas do Istio exportadas pelo OTel e visiveis no Prometheus/Grafana self-hosted.

Checklist operacional (drill-down):
- [ ] Instalar Istio com profile otimizado para kind.
- [ ] Habilitar sidecar injection no namespace `apps`.
- [ ] Ativar `PeerAuthentication` strict para mTLS.
- [ ] Criar `RequestAuthentication` e `AuthorizationPolicy` iniciais.
- [ ] Criar `VirtualService` e `DestinationRule` para canary.
- [ ] Validar trÃ¡fego e polÃ­ticas de acesso no mesh.
- [ ] Validar mÃ©tricas do Istio no Grafana via OTel.
- [ ] Documentar padrÃµes de rede/seguranÃ§a no `runbooks.md`.

## Fase 8 - Integracoes AWS low-cost (Semanas 10-11)
Objetivo:
- Integrar o laboratÃ³rio local com serviÃ§os AWS de baixo custo/free tier.

EntregÃ¡veis:
- ECR para armazenar imagens do pipeline Jenkins.
- SQS para fluxo assÃ­ncrono real da aplicaÃ§Ã£o.
- DynamoDB (on-demand) para estado leve/deduplicaÃ§Ã£o.
- Lambda para automaÃ§Ã£o event-driven simples.
- Terraform com modulos para os recursos AWS usados.
- AWS Budgets com alertas de custo baixo (ex: USD 5 e USD 10).

CritÃ©rios de pronto:
- Deploy no kind consumindo imagem do ECR.
- Aplicacao processando mensagens reais do SQS.
- Custos mensais dentro do limite definido no projeto.

Checklist operacional (drill-down):
- [ ] Criar repositÃ³rio ECR e permissao de push/pull.
- [ ] Configurar Jenkins para publicar imagens no ECR.
- [ ] Criar fila SQS e parametros de retentativa/DLQ.
- [ ] Configurar consumo de SQS no worker.
- [ ] Criar tabela DynamoDB para estado/deduplicaÃ§Ã£o.
- [ ] Criar Lambda inicial de automaÃ§Ã£o event-driven.
- [ ] Configurar AWS Budgets com alertas de baixo custo.
- [ ] Validar fluxo completo app -> SQS -> worker -> DynamoDB.

## Fase 9 - Performance e carga com K6 (Semanas 11-12)
Objetivo:
- Validar comportamento da plataforma sob carga com cenÃ¡rios reproduziveis.

EntregÃ¡veis:
- Suite de testes K6 versionada:
  - `smoke`
  - `load`
  - `stress`
- Cenarios dedicados para `app-python` e `app-java` para comparativo de performance.
- Thresholds definidos (latÃªncia e taxa de erro).
- Exportacao de mÃ©tricas do K6 via OTel para Prometheus/Grafana self-hosted.
- Job agendado de baseline semanal de performance.

CritÃ©rios de pronto:
- Relatorio de carga gerado automaticamente no pipeline.
- Regressao de performance detectada por threshold no CI.
- Comparativo baseline Python vs Java registrado na documentaÃ§Ã£o.

Checklist operacional (drill-down):
- [ ] Criar scripts K6 `smoke`, `load` e `stress`.
- [ ] Definir thresholds de erro e latÃªncia por cenÃ¡rio.
- [ ] Integrar execuÃ§Ã£o K6 ao pipeline Jenkins.
- [ ] Exportar mÃ©tricas K6 para stack de observabilidade.
- [ ] Gerar relatorio automÃ¡tico por execuÃ§Ã£o.
- [ ] Rodar baseline semanal e salvar histÃ³rico.
- [ ] Comparar performance Python vs Java com dados objetivos.
- [ ] Documentar tuning e gargalos encontrados.

## Fase 10 - Confiabilidade SRE (Semanas 12-14)
Objetivo:
- Introduzir disciplina de SLI/SLO e resposta a incidentes.

EntregÃ¡veis:
- Definicao de SLIs:
  - disponibilidade
  - latÃªncia
  - taxa de erro
- SLOs mensais definidos e medidos.
- Error budget e polÃ­tica de congelamento de mudanÃ§as.
- Game days (falhas simuladas) e postmortems.
- LitmusChaos instalado e configurado com experimentos iniciais:
  - pod-delete
  - network-latency
  - cpu-hog
- Relatorios de resiliÃªncia conectando experimento, impacto em SLI e aÃ§Ã£o corretiva.

CritÃ©rios de pronto:
- 2 ou mais incidentes simulados com aprendizado registrado.
- DecisÃµes orientadas por SLO em pelo menos 1 ciclo de entrega.
- Pelo menos 3 experimentos LitmusChaos executados com rollback validado.

Checklist operacional (drill-down):
- [ ] Definir SLIs e SLOs por serviÃ§o.
- [ ] Criar painel de error budget e indicadores de confiabilidade.
- [ ] Instalar LitmusChaos no cluster.
- [ ] Executar experimento `pod-delete` com coleta de evidÃªncias.
- [ ] Executar experimento `network-latency` com coleta de evidÃªncias.
- [ ] Executar experimento `cpu-hog` com coleta de evidÃªncias.
- [ ] Validar comportamento de auto-healing/rollback.
- [ ] Registrar postmortem e aÃ§Ãµes preventivas.

## Fase 11 - SeguranÃ§a e governanÃ§a (Semanas 14-15)
Objetivo:
- Aplicar seguranÃ§a de supply chain e polÃ­ticas de cluster.

EntregÃ¡veis:
- Kyverno com polÃ­ticas basicas:
  - bloquear `latest`
  - exigir requests/limits
  - exigir probes
- Scan contÃ­nuo de imagens/dependÃªncias.
- Gestao de segredos com Sealed Secrets ou SOPS.

CritÃ©rios de pronto:
- PolÃ­ticas impedem deploys fora do padrÃ£o.
- Segredos fora do repositÃ³rio em texto puro.

Checklist operacional (drill-down):
- [ ] Instalar Kyverno e validar admission webhooks.
- [ ] Criar polÃ­tica para bloquear imagem `latest`.
- [ ] Criar polÃ­tica para exigir requests/limits.
- [ ] Criar polÃ­tica para exigir probes.
- [ ] Integrar scan de dependÃªncias/imagens no CI.
- [ ] Definir padrÃ£o de gestao de segredos (Sealed Secrets ou SOPS).
- [ ] Migrar segredos existentes para padrÃ£o seguro.
- [ ] Testar bloqueio de manifest fora de conformidade.

## Fase 12 - Fechamento de portfÃ³lio (Semanas 15-17)
Objetivo:
- Consolidar projeto para demonstracao profissional.

EntregÃ¡veis:
- DocumentaÃ§Ã£o final:
  - arquitetura
  - roadmap executado
  - runbooks
  - postmortems
- Demo guiada com cenÃ¡rio de incidente e recuperacao.
- Backlog de melhorias futuras.

CritÃ©rios de pronto:
- Qualquer pessoa consegue subir ambiente seguindo docs.
- Projeto demonstravel em 15-20 minutos.

Checklist operacional (drill-down):
- [ ] Consolidar documentaÃ§Ã£o final de arquitetura.
- [ ] Revisar roadmap com status real de cada fase.
- [ ] Revisar e consolidar runbooks operacionais.
- [ ] Revisar postmortems e principais aprendizados.
- [ ] Preparar roteiro de demo (15-20 min).
- [ ] Validar demo end-to-end em ambiente limpo.
- [ ] Criar backlog priorizado de melhorias futuras.
- [ ] Publicar release/tag de fechamento do projeto.

## Fase 13 - IA aplicada a observabilidade (Semanas 17-18)
Objetivo:
- Aumentar capacidade de investigaÃ§Ã£o com recursos de IA no Grafana sobre dados de mÃ©tricas, logs e traces.

EntregÃ¡veis:
- Plugins/recursos de IA no Grafana configurados para assistencia de troubleshooting.
- Fluxo de correlaÃ§Ã£o com IA usando:
  - Prometheus (mÃ©tricas)
  - Loki (logs)
  - Tempo (traces)
- Playbook de anÃ¡lise assistida por IA para incidentes comuns.
- ValidaÃ§Ã£o com 2 cenÃ¡rios reais de troubleshooting (erro alto e latÃªncia alta).

CritÃ©rios de pronto:
- IA retorna hipÃ³teses e links de correlaÃ§Ã£o entre mÃ©tricas, logs e traces.
- Tempo medio de diagnÃ³stico reduzido nos cenÃ¡rios validados.
- Limitacoes e riscos de uso de IA documentados (falsos positivos, privacidade, dependencia de contexto).

Checklist operacional (drill-down):
- [ ] Habilitar plugin/recurso de IA no Grafana.
- [ ] Validar conexao do recurso de IA com datasources do Grafana.
- [ ] Configurar contexto para correlaÃ§Ã£o Prometheus/Loki/Tempo.
- [ ] Executar cenÃ¡rio de erro alto e medir tempo de diagnÃ³stico.
- [ ] Executar cenÃ¡rio de latÃªncia alta e medir tempo de diagnÃ³stico.
- [ ] Comparar diagnÃ³stico assistido por IA vs processo manual.
- [ ] Documentar limites, riscos e boas prÃ¡ticas de uso.
- [ ] Registrar playbook de troubleshooting assistido por IA.

## KPIs de sucesso do projeto
- Lead time de mudanÃ§a reduzido ao longo das fases.
- Taxa de falha de deploy em queda.
- MTTR melhorando nos game days.
- Cobertura de telemetria e alertas aumentando por release.

## Proximos incrementos (opcional)
- Progressive delivery (Argo Rollouts).
- Multi-cluster e promoÃ§Ã£o entre ambientes.

