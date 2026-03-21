# Roadmap: SRE/DevOps Lab com kind

## Visão geral
Projeto prático de Platform Engineering/DevOps/SRE para construir, operar e evoluir uma plataforma cloud-native local em Kubernetes kind, com foco em aprendizado aplicado e documentado.

Escopo técnico coberto:
- Entrega de software: CI com Jenkins, CD GitOps com Argo CD e estratégias de canary + auto rollback por métrica.
- Infraestrutura como código: provisionamento e padronização com Terraform e Ansible.
- Observabilidade end-to-end: OpenTelemetry + Prometheus + Grafana + Loki + Tempo (self-hosted no kind).
- Confiabilidade e resiliência: SLI/SLO, runbooks, game days e chaos engineering com LitmusChaos.
- Performance e capacidade: testes de carga com K6 e comparativo Python vs Java.
- FinOps: visibilidade de custo por namespace/workload com OpenCost.
- Integração cloud low-cost: ECR, SQS, DynamoDB, Lambda e Budgets na AWS.
- Evolução assistida por IA: investigação de incidentes no Grafana com correlação entre métricas, logs e traces.

Resultado esperado:
- Pipeline ponta a ponta reproduzível, com operação orientada por métricas e documentação de conhecimento para retomada rápida.

Aplicações alvo:
- `app-python` (FastAPI + worker)
- `app-java` (Spring Boot)

Duração sugerida: 16 a 18 semanas (ajustável).

## Status atual
- Fase 0: concluída.
- Fase 1: concluída.
- Fase 2: concluída.
- Próxima fase: Fase 3 (CD GitOps com Argo CD).

## Fase 0 - Fundação e padrões (Semana 1)
Objetivo:
- Preparar estrutura do projeto, padrões de código e base de documentação.

Entregáveis:
- Repositório criado com estrutura:
  - `apps/`
  - `infra/terraform/`
  - `infra/ansible/`
  - `charts/`
  - `gitops/`
  - `observability/`
  - `docs/`
- Convenções de branch e PR definidas.
- Templates de issue/PR e checklist de qualidade.

Critérios de pronto:
- Projeto inicia com um comando documentado (`make bootstrap` ou script equivalente).
- README com pre-requisitos e fluxo de contribuição.

Checklist operacional (drill-down):
- [x] Validar estrutura mínima de pastas do repositório.
- [x] Criar/atualizar `README.md` com pre-requisitos e fluxo inicial.
- [x] Criar/atualizar `docs/CONTRIBUTING.md` com padrões de branch e PR.
- [x] Criar templates em `.github` para PR e Issues.
- [x] Criar `Makefile` com alvo `bootstrap` (ou script equivalente).
- [x] Validar `.gitignore` com itens de Terraform e ambiente local.
- [x] Registrar Fase 0 em `docs/knowledge.md`.
- [x] Publicar base inicial no GitHub (main sincronizada com origin/main).

Data de execução da Fase 0: 2026-02-27

## Fase 1 - Bootstrap local (Semanas 1-2)
Objetivo:
- Subir o laboratório local com kind e dependências base.

Entregáveis:
- Ansible para configurar host (docker, kubectl, kind, helm).
- Cluster kind criado com configuração versionada.
- Namespaces base: `cicd`, `argocd`, `observability`, `istio-system`, `apps`.
- Ingress controller instalado.

Critérios de pronto:
- Cluster sobe de forma reproduzível.
- Script de destroy/recreate documentado.

Checklist operacional (drill-down):
- [x] Criar estrutura inicial em `infra/ansible/` para bootstrap do host.
- [x] Definir variáveis e inventario do Ansible para ambiente local.
- [x] Criar playbook para instalar Docker.
- [x] Criar playbook para instalar `kubectl`.
- [x] Criar playbook para instalar `kind`.
- [x] Criar playbook para instalar `helm`.
- [x] Validar versões instaladas (`docker`, `kubectl`, `kind`, `helm`).
- [x] Criar arquivo de configuração versionado do cluster kind.
- [x] Subir cluster kind com comando documentado.
- [x] Verificar estado do cluster (`kubectl get nodes`).
- [x] Criar namespaces `cicd`, `argocd`, `observability`, `istio-system`, `apps`.
- [x] Validar namespaces criados com `kubectl get ns`.
- [x] Instalar ingress controller no cluster.
- [x] Validar ingress controller com pods `Running`.
- [x] Criar script de `destroy` do cluster.
- [x] Criar script de `recreate` (destroy + create).
- [x] Documentar passos de bootstrap no `runbooks.md`.
- [x] Registrar aprendizados e evidências da fase no `knowledge.md`.
- [x] Executar teste de reproducibilidade: destruir e recriar cluster do zero.

Nota operacional (WSL + `/mnt/c`):
- Ao executar Ansible em diretório world-writable, `ansible.cfg` pode ser ignorado.
- Fluxo suportado no projeto: `make ansible-bootstrap` com inventário/vars/roles definidos explicitamente no comando.
- Para este laboratório, Docker será provido por Docker Desktop (`install_docker: false`), sem instalar `docker.io` via Ansible.

Data de execução da Fase 1: 2026-02-28

## Fase 2 - CI com Jenkins (Semanas 2-4)
Objetivo:
- Criar pipeline de integração continua robusta.

Entregáveis:
- Jenkins instalado no cluster (Helm).
- Pipelines declarativas para `app-python` e `app-java` com estágios:
  - lint
  - teste unitário
  - teste de integração
  - build imagem
  - scan (Trivy)
  - smoke test de carga (K6)
  - push para registry
- Dockerfiles de `app-python` e `app-java` com:
  - multi-stage builds
  - `HEALTHCHECK`
  - camadas otimizadas para cache e tamanho final
- Badges e status checks no GitHub.

Critérios de pronto:
- PR bloqueado sem passar pipeline.
- Build reproduzível por tag e commit SHA.
- Imagens finais menores e com tempo de build reduzido após otimização de camadas.

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

Checklist operacional (drill-down) - Evolução Fase 2: execução em pods dinâmicos:
- [x] Validar que o plugin `kubernetes` está instalado e saudável no Jenkins.
- [x] Confirmar configuração da cloud Kubernetes em `Manage Jenkins > Clouds` apontando para o cluster local.
- [x] Validar ServiceAccount do Jenkins com RBAC para criar/listar/deletar pods no namespace de execução.
- [x] Definir namespace padrão de agentes efêmeros (ex.: `cicd`) e convenção de labels.
- [x] Criar imagem base de agent com ferramentas necessárias para CI (`git`, `docker/kaniko`, `trivy`, `k6`, etc.).
- [x] Atualizar `Jenkinsfile` de `app-python` para usar `agent { kubernetes { ... } }`.
- [x] Atualizar `Jenkinsfile` de `app-java` para usar `agent { kubernetes { ... } }`.
- [x] Configurar `podTemplate` com `resources.requests/limits` e `workspaceVolume` adequados.
- [ ] Executar build de validação e comprovar que stages rodam em pod efêmero (não no controller `jenkins-0`).
- [ ] Coletar evidências (`Console Output`, nome do pod agent, duração e consumo) e registrar em `knowledge.md`.
- [x] Atualizar `runbooks.md` com troubleshooting de falhas comuns de agent dinâmico (RBAC, imagem, pull e timeout).

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

Entregáveis:
- Argo CD instalado e acessível.
- Apps Helm registradas via `Application`/`ApplicationSet`:
  - `app-python`
  - `app-java`
- Estratégia de valores por ambiente (`dev-local`, `staging-local` opcional).
- Rollback via `git revert`.
- Subtopico ArgoCD: canary deployment com Argo Rollouts.
- `AnalysisTemplate` ligado ao Prometheus para validação por métrica.
- Auto rollback quando latência/erros ultrapassarem thresholds definidos.

Critérios de pronto:
- Merge em `main` gera deploy automático no kind.
- Drift detectado e corrigido pelo Argo CD.
- Canary executado com promoção automática quando métricas estiverem saudaveis.
- Rollback automático comprovado por falha controlada de métrica.

Checklist operacional (drill-down):
- [ ] Instalar Argo CD no namespace `argocd`.
- [ ] Criar `Application`/`ApplicationSet` para `app-python`.
- [ ] Criar `Application`/`ApplicationSet` para `app-java`.
- [ ] Configurar sincronização automática e política de self-heal.
- [ ] Instalar/ativar Argo Rollouts para canary.
- [ ] Criar `AnalysisTemplate` com métricas de erro e latência.
- [ ] Simular degradação e validar auto rollback.
- [ ] Registrar fluxo GitOps e canary em `runbooks.md`.

## Fase 4 - Infra as Code com Terraform (Semanas 5-6)
Objetivo:
- Padronizar provisionamento de componentes Kubernetes por código.

Entregáveis:
- Terraform para addons base:
  - namespaces
  - service accounts e RBAC
  - configurações de observabilidade
  - recursos de suporte para apps
- States e variáveis organizados.

Critérios de pronto:
- `terraform plan/apply` com output limpo e previsivel.
- Recursos críticos sem configuração manual ad-hoc.

Checklist operacional (drill-down):
- [ ] Definir providers e backend de state Terraform.
- [ ] Criar módulo/base para namespaces e RBAC.
- [ ] Criar módulo/base para recursos de observabilidade.
- [ ] Criar variáveis e `terraform.tfvars.example`.
- [ ] Executar `terraform fmt` e validação.
- [ ] Executar `terraform plan` e revisar mudanças.
- [ ] Executar `terraform apply` em ambiente local.
- [ ] Documentar comandos e ordem de execução no `runbooks.md`.

### Fase 4.5 - Evolução de domínio da aplicação (Semanas 6-7)
Objetivo complementar:
- Evoluir as aplicações de exemplo para um cenário distribuído mais realista, preparando o terreno para observabilidade avançada na fase seguinte.

Entregáveis complementares:
- APIs separadas por responsabilidade:
  - BFF (`bff`)
  - Serviço de domínio (`srv`)
- Contratos de API versionados e documentados (OpenAPI/Swagger).
- Persistência com banco de dados relacional e migrações versionadas.
- Camada de cache com política de TTL e estratégia de invalidação.
- Mensageria com processamento assíncrono via worker idempotente.
- Fluxo de telemetria ponta a ponta pronto para instrumentação OTel (HTTP + DB + cache + fila).

Critérios de pronto complementares:
- Fluxo principal de negócio atravessa BFF, serviço, banco, cache e worker assíncrono.
- Reprocessamento de mensagens não gera efeito colateral (idempotência comprovada).
- Contratos de API e eventos versionados e documentados.
- Aplicações preparadas para instrumentação distribuída completa na Fase 5 sem refactor estrutural.

Checklist operacional (drill-down) - Subtópico da Fase 4:
- [ ] Definir domínio funcional mínimo (caso de uso principal) e fluxo E2E alvo.
- [ ] Criar estrutura de serviços `bff` e `srv` no repositório com responsabilidades claras.
- [ ] Definir e publicar contratos de API (OpenAPI) para `bff` e `srv`.
- [ ] Provisionar banco de dados no cluster local (ex.: Postgres) para desenvolvimento.
- [ ] Implementar migrações versionadas (ex.: Flyway/Alembic) e política de rollback.
- [ ] Implementar acesso a cache (ex.: Redis) com TTL por chave e regras de invalidação.
- [ ] Definir broker de mensageria (ex.: RabbitMQ/Kafka) e tópicos/filas iniciais.
- [ ] Implementar publicação de eventos no `srv` com payload versionado.
- [ ] Implementar worker consumidor com deduplicação/idempotência.
- [ ] Implementar testes unitários e de integração para DB, cache e fila.
- [ ] Atualizar pipelines CI para validar contratos, migrações e fluxo assíncrono.
- [ ] Registrar arquitetura, decisões e trade-offs no `docs/knowledge.md`.
- [ ] Atualizar runbooks operacionais para troubleshooting de DB/cache/mensageria.

## Fase 5 - OpenTelemetry end-to-end (Semanas 6-8)
Objetivo:
- Instrumentar aplicação e coletar traces, métricas e logs com OpenTelemetry usando backend self-hosted no kind.

Entregáveis:
- Instrumentacao OTel em `app-python`, `app-python-worker` e `app-java`:
  - spans de entrada/saida HTTP
  - spans de processamento assíncrono
  - propagacao de contexto entre componentes
- OTel Collector implantado com pipelines:
  - receiver OTLP (gRPC/HTTP)
  - processors (`batch`, `memory_limiter`, `resource`)
  - exporters para stack observability local (Prometheus, Loki e Tempo)
- Correlacao logs x traces com `trace_id` e `span_id`.

Critérios de pronto:
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
- [ ] Validar correlação `trace_id` entre logs e traces.
- [ ] Criar dashboards iniciais de RED metrics.
- [ ] Registrar configuração e troubleshooting no `knowledge.md`.

## Fase 6 - Observabilidade e operação (Semanas 8-9)
Objetivo:
- Tornar o ambiente observavel e acionável.

Entregáveis:
- Observabilidade operacional ativa no kind com configuração manual de:
  - Prometheus (scrape jobs, relabeling, retention)
  - Grafana (datasources, dashboards, pastas e provisionamento)
  - Loki (pipeline de logs e labels)
  - Tempo (armazenamento e consulta de traces)
  - OTel Collector (pipelines e roteamento por sinal)
  - OpenCost (alocação de custos por namespace/workload/label)
- Dashboards:
  - visao executiva (SLO)
  - visao técnica (infra + aplicação)
  - visao FinOps (custo por serviço e tendência semanal)
- Regras de alerta:
  - erro alto
  - latência alta
  - fila acumulando
  - restart em loop

Critérios de pronto:
- Alertas acionam com testes controlados.
- Runbooks vinculados a cada alerta critico.
- OpenCost operando com relatórios de custo por namespace e workload.

Checklist operacional (drill-down):
- [ ] Instalar Prometheus com scrape jobs e retention definidos.
- [ ] Instalar Grafana com provisionamento de datasources.
- [ ] Instalar Loki e validar ingestao de logs.
- [ ] Instalar Tempo e validar consulta de traces.
- [ ] Integrar OTel Collector com toda stack observability.
- [ ] Instalar OpenCost e validar métricas de custo.
- [ ] Criar dashboards: executivo, técnico e FinOps.
- [ ] Criar alertas e vincular runbooks para cada alerta critico.

## Fase 7 - Service Mesh com Istio (Semanas 9-10)
Objetivo:
- Controlar tráfego, segurança e resiliência entre microservicos com service mesh.

Entregáveis:
- Istio instalado com profile `demo` ou `default` otimizado para kind.
- Sidecar injection habilitada no namespace `apps`.
- mTLS em modo strict para comunicação interna.
- Políticas:
  - `PeerAuthentication`
  - `RequestAuthentication`
  - `AuthorizationPolicy`
- Roteamento progressivo:
  - `VirtualService` + `DestinationRule`
  - canary inicial (exemplo: 90/10)

Critérios de pronto:
- Serviços comunicando somente via mesh.
- Canary executado com rollback por configuração GitOps.
- Metricas do Istio exportadas pelo OTel e visiveis no Prometheus/Grafana self-hosted.

Checklist operacional (drill-down):
- [ ] Instalar Istio com profile otimizado para kind.
- [ ] Habilitar sidecar injection no namespace `apps`.
- [ ] Ativar `PeerAuthentication` strict para mTLS.
- [ ] Criar `RequestAuthentication` e `AuthorizationPolicy` iniciais.
- [ ] Criar `VirtualService` e `DestinationRule` para canary.
- [ ] Validar tráfego e políticas de acesso no mesh.
- [ ] Validar métricas do Istio no Grafana via OTel.
- [ ] Documentar padrões de rede/segurança no `runbooks.md`.

### Estudo complementar da Fase 7 - API Gateway com Kong OSS (laboratório)
Objetivo complementar:
- Explorar conceitos de API Gateway em ambiente local para comparação prática com abordagem managed na AWS.

Entregáveis complementares:
- Kong OSS instalado no cluster local.
- Rotas básicas publicadas para `bff`/`srv`.
- Políticas iniciais de gateway:
  - autenticação básica/token
  - rate limit
  - request/response transform (quando aplicável)
- Documento comparativo Kong OSS vs AWS API Gateway no `docs/knowledge.md`.

Checklist operacional (drill-down) - Estudo complementar:
- [ ] Instalar Kong OSS no cluster local.
- [ ] Publicar rota de API para pelo menos um serviço de aplicação.
- [ ] Aplicar rate limiting e validar comportamento.
- [ ] Aplicar política simples de autenticação e validar acesso.
- [ ] Coletar métricas/logs de gateway no Grafana/Loki.
- [ ] Registrar trade-offs e decisão arquitetural para fases AWS.

## Fase 8 - Integracoes AWS low-cost (Semanas 10-11)
Objetivo:
- Integrar o laboratório local com serviços AWS de baixo custo/free tier.

Entregáveis:
- ECR para armazenar imagens do pipeline Jenkins.
- SQS para fluxo assíncrono real da aplicação.
- DynamoDB (on-demand) para estado leve/deduplicação.
- Lambda para automação event-driven simples.
- AWS API Gateway para exposição e governança de APIs.
- Terraform com modulos para os recursos AWS usados.
- AWS Budgets com alertas de custo baixo (ex: USD 5 e USD 10).

Critérios de pronto:
- Deploy no kind consumindo imagem do ECR.
- Aplicacao processando mensagens reais do SQS.
- Endpoint publicado no AWS API Gateway com autenticação e throttling básico.
- Custos mensais dentro do limite definido no projeto.

Checklist operacional (drill-down):
- [ ] Criar repositório ECR e permissao de push/pull.
- [ ] Configurar Jenkins para publicar imagens no ECR.
- [ ] Criar fila SQS e parametros de retentativa/DLQ.
- [ ] Configurar consumo de SQS no worker.
- [ ] Criar tabela DynamoDB para estado/deduplicação.
- [ ] Criar Lambda inicial de automação event-driven.
- [ ] Criar API HTTP no AWS API Gateway integrada ao backend definido.
- [ ] Configurar autenticação/autorização inicial no API Gateway (IAM/JWT/API Key).
- [ ] Configurar throttling/rate limit e logs no CloudWatch.
- [ ] Configurar AWS Budgets com alertas de baixo custo.
- [ ] Validar fluxo completo app -> SQS -> worker -> DynamoDB.

## Fase 9 - Performance e carga com K6 (Semanas 11-12)
Objetivo:
- Validar comportamento da plataforma sob carga com cenários reproduziveis.

Entregáveis:
- Suite de testes K6 versionada:
  - `smoke`
  - `load`
  - `stress`
- Cenarios dedicados para `app-python` e `app-java` para comparativo de performance.
- Thresholds definidos (latência e taxa de erro).
- Exportacao de métricas do K6 via OTel para Prometheus/Grafana self-hosted.
- Job agendado de baseline semanal de performance.

Critérios de pronto:
- Relatorio de carga gerado automaticamente no pipeline.
- Regressao de performance detectada por threshold no CI.
- Comparativo baseline Python vs Java registrado na documentação.

Checklist operacional (drill-down):
- [ ] Criar scripts K6 `smoke`, `load` e `stress`.
- [ ] Definir thresholds de erro e latência por cenário.
- [ ] Integrar execução K6 ao pipeline Jenkins.
- [ ] Exportar métricas K6 para stack de observabilidade.
- [ ] Gerar relatorio automático por execução.
- [ ] Rodar baseline semanal e salvar histórico.
- [ ] Comparar performance Python vs Java com dados objetivos.
- [ ] Documentar tuning e gargalos encontrados.

## Fase 10 - Confiabilidade SRE (Semanas 12-14)
Objetivo:
- Introduzir disciplina de SLI/SLO e resposta a incidentes.

Entregáveis:
- Definicao de SLIs:
  - disponibilidade
  - latência
  - taxa de erro
- SLOs mensais definidos e medidos.
- Error budget e política de congelamento de mudanças.
- Game days (falhas simuladas) e postmortems.
- LitmusChaos instalado e configurado com experimentos iniciais:
  - pod-delete
  - network-latency
  - cpu-hog
- Relatorios de resiliência conectando experimento, impacto em SLI e ação corretiva.

Critérios de pronto:
- 2 ou mais incidentes simulados com aprendizado registrado.
- Decisões orientadas por SLO em pelo menos 1 ciclo de entrega.
- Pelo menos 3 experimentos LitmusChaos executados com rollback validado.

Checklist operacional (drill-down):
- [ ] Definir SLIs e SLOs por serviço.
- [ ] Criar painel de error budget e indicadores de confiabilidade.
- [ ] Instalar LitmusChaos no cluster.
- [ ] Executar experimento `pod-delete` com coleta de evidências.
- [ ] Executar experimento `network-latency` com coleta de evidências.
- [ ] Executar experimento `cpu-hog` com coleta de evidências.
- [ ] Validar comportamento de auto-healing/rollback.
- [ ] Registrar postmortem e ações preventivas.

## Fase 11 - Segurança e governança (Semanas 14-15)
Objetivo:
- Aplicar segurança de supply chain e políticas de cluster.

Entregáveis:
- Kyverno com políticas basicas:
  - bloquear `latest`
  - exigir requests/limits
  - exigir probes
- Scan contínuo de imagens/dependências.
- Gestao de segredos com Sealed Secrets ou SOPS.

Critérios de pronto:
- Políticas impedem deploys fora do padrão.
- Segredos fora do repositório em texto puro.

Checklist operacional (drill-down):
- [ ] Instalar Kyverno e validar admission webhooks.
- [ ] Criar política para bloquear imagem `latest`.
- [ ] Criar política para exigir requests/limits.
- [ ] Criar política para exigir probes.
- [ ] Integrar scan de dependências/imagens no CI.
- [ ] Definir padrão de gestao de segredos (Sealed Secrets ou SOPS).
- [ ] Migrar segredos existentes para padrão seguro.
- [ ] Testar bloqueio de manifest fora de conformidade.

## Fase 12 - Fechamento de portfólio (Semanas 15-17)
Objetivo:
- Consolidar projeto para demonstracao profissional.

Entregáveis:
- Documentação final:
  - arquitetura
  - roadmap executado
  - runbooks
  - postmortems
- Demo guiada com cenário de incidente e recuperacao.
- Backlog de melhorias futuras.

Critérios de pronto:
- Qualquer pessoa consegue subir ambiente seguindo docs.
- Projeto demonstravel em 15-20 minutos.

Checklist operacional (drill-down):
- [ ] Consolidar documentação final de arquitetura.
- [ ] Revisar roadmap com status real de cada fase.
- [ ] Revisar e consolidar runbooks operacionais.
- [ ] Revisar postmortems e principais aprendizados.
- [ ] Preparar roteiro de demo (15-20 min).
- [ ] Validar demo end-to-end em ambiente limpo.
- [ ] Criar backlog priorizado de melhorias futuras.
- [ ] Publicar release/tag de fechamento do projeto.

## Fase 13 - IA aplicada a observabilidade (Semanas 17-18)
Objetivo:
- Aumentar capacidade de investigação com recursos de IA no Grafana sobre dados de métricas, logs e traces.

Entregáveis:
- Plugins/recursos de IA no Grafana configurados para assistencia de troubleshooting.
- Fluxo de correlação com IA usando:
  - Prometheus (métricas)
  - Loki (logs)
  - Tempo (traces)
- Playbook de análise assistida por IA para incidentes comuns.
- Validação com 2 cenários reais de troubleshooting (erro alto e latência alta).

Critérios de pronto:
- IA retorna hipóteses e links de correlação entre métricas, logs e traces.
- Tempo medio de diagnóstico reduzido nos cenários validados.
- Limitacoes e riscos de uso de IA documentados (falsos positivos, privacidade, dependencia de contexto).

Checklist operacional (drill-down):
- [ ] Habilitar plugin/recurso de IA no Grafana.
- [ ] Validar conexao do recurso de IA com datasources do Grafana.
- [ ] Configurar contexto para correlação Prometheus/Loki/Tempo.
- [ ] Executar cenário de erro alto e medir tempo de diagnóstico.
- [ ] Executar cenário de latência alta e medir tempo de diagnóstico.
- [ ] Comparar diagnóstico assistido por IA vs processo manual.
- [ ] Documentar limites, riscos e boas práticas de uso.
- [ ] Registrar playbook de troubleshooting assistido por IA.

## KPIs de sucesso do projeto
- Lead time de mudança reduzido ao longo das fases.
- Taxa de falha de deploy em queda.
- MTTR melhorando nos game days.
- Cobertura de telemetria e alertas aumentando por release.

## Proximos incrementos (opcional)
- Progressive delivery (Argo Rollouts).
- Multi-cluster e promoção entre ambientes.

