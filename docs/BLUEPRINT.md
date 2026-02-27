# Blueprint: Plataforma DevOps/SRE em Kind

## 1. Objetivo
Construir um ambiente local de engenharia de plataforma para praticar CI/CD, GitOps, IaC, observabilidade e operacao SRE com ferramentas open source.

Diagrama de arquitetura: `docs/ARCHITECTURE.excalidraw`

Stack principal:
- GitHub
- Jenkins
- Terraform
- Ansible
- Kubernetes (kind)
- Helm
- Argo CD
- Istio (service mesh)
- OpenTelemetry (camada de observabilidade agnostica)
- Prometheus (self-hosted)
- Grafana (self-hosted)
- Loki (self-hosted)
- Tempo (self-hosted)
- K6 (teste de carga/performance)

Stack complementar recomendada:
- OpenTelemetry Collector
- Alertmanager
- OpenCost
- LitmusChaos
- Trivy
- Kyverno
- External Secrets + Sealed Secrets (ou SOPS)

## 2. Escopo funcional do laboratorio
- Duas aplicacoes de referencia com deploy em Kubernetes:
  - `app-python` (FastAPI + worker)
  - `app-java` (Spring Boot)
- Pipeline CI no Jenkins com testes, build de imagem, scan e push.
- CD GitOps com Argo CD observando repositorio de manifests/Helm values.
- Service mesh com Istio para trafego, seguranca mTLS e politicas de roteamento.
- Provisionamento e configuracao por codigo (Terraform + Ansible).
- Observabilidade completa:
  - Coleta e padronizacao com OpenTelemetry (SDK + Collector)
  - Metricas, logs e traces enviados para stack self-hosted no kind
  - Prometheus + Grafana + Loki + Tempo com configuracao manual
  - Visibilidade de custo por namespace/workload com OpenCost (FinOps)
- Praticas SRE:
  - SLI/SLO e error budget
  - Chaos engineering para validacao de resiliencia
  - Analise assistida por IA no Grafana para acelerar troubleshooting
  - Runbooks
  - Simulacao de incidentes e rollback

## 3. Arquitetura alvo
Fluxo de mudanca:
1. Desenvolvedor abre PR no GitHub.
2. Jenkins executa CI (lint, testes, cobertura, scan de seguranca).
3. Jenkins publica imagem versionada e atualiza artefato GitOps (chart/tag).
4. Argo CD detecta mudanca e sincroniza ambiente no kind.
5. OTel Collector recebe telemetria da app e exporta:
   - Prometheus remote write / scrape endpoint para metricas
   - Loki para logs
   - Tempo para traces
6. Grafana consolida paineis e alertas.

Fluxo de runtime:
1. Usuario chama `app-python` ou `app-java`.
2. As aplicacoes geram spans, logs estruturados e metricas.
3. `app-python-worker` processa fila e gera spans encadeados (trace distribuido).
4. Alertmanager envia alertas quando SLO/erro/latencia degradam.

## 4. Estrutura de repositorios (modelo recomendado)
Opcao A (monorepo):
- `apps/` codigo das aplicacoes
  - `apps/app-python/`
  - `apps/app-java/`
- `charts/` Helm charts
  - `charts/app-python/`
  - `charts/app-java/`
- `infra/terraform/` infraestrutura base do cluster e addons
- `infra/ansible/` bootstrap de host e ferramentas locais
- `gitops/` objetos Argo CD e valores por ambiente
- `observability/` dashboards, regras e alertas
- `docs/` ADRs, runbooks e roadmap

Opcao B (multirepo):
- `platform-infra` (Terraform/Ansible)
- `platform-gitops` (Argo CD/charts/values)
- `sample-app` (aplicacao)

Para projeto pessoal, comecar por monorepo simplifica.

## 5. Ambientes
- `dev-local`: unico cluster kind com namespaces separados por contexto:
  - `cicd` (Jenkins)
  - `argocd`
  - `observability`
  - `istio-system`
  - `apps`
- Evolucao opcional:
  - `staging-local` (segundo cluster kind)
  - Politica de promocao manual entre ambientes

## 6. Modelo de entrega (GitOps + CI)
- Branches:
  - `main`: estado desejado pronto para deploy
  - `feature/*`: desenvolvimento
- CI no PR:
  - lint + testes + SAST/dependencies + scan da imagem + smoke de carga com K6 (para Python e Java)
- CI no merge:
  - build final + push de 2 imagens + atualizacao de tags no repositorio GitOps
- CD:
  - Argo CD sincroniza automatico em `dev-local` para `app-python` e `app-java`
  - rollback via Git revert
  - Subtopico: Canary deployment + auto rollback por metrica.
  - Argo Rollouts para estrategia canary progressiva.
  - `AnalysisTemplate` com metricas de erro/latencia (Prometheus).
  - Rollback automatico quando threshold de metrica for violado.

Padroes de containerizacao (Docker):
- Multi-stage builds obrigatorio para reduzir imagem final.
- `HEALTHCHECK` no Dockerfile para validacao basica de liveness da imagem.
- Otimizacao de camadas para melhorar cache e reduzir tempo de build.

## 7. Blueprint de OpenTelemetry
Instrumentacao minima:
- App Python e App Java:
  - traces HTTP de entrada/saida
  - metricas RED (rate, errors, duration)
  - logs estruturados com `trace_id` e `span_id`
- Worker Python:
  - spans de consumo e processamento
  - propagacao de contexto de trace via fila/mensagem
  - metricas de throughput e falhas

Padrao de atributos:
- `service.name`, `service.version`, `deployment.environment`
- `http.method`, `http.route`, `http.status_code`
- `messaging.system`, `messaging.operation`, `messaging.destination`

OTel Collector (pipelines):
- Recepcao: OTLP gRPC/HTTP
- Processadores: `batch`, `memory_limiter`, `resource`, `attributes`
- Exportadores:
  - `prometheus`/`prometheusremotewrite` para metricas
  - `loki` para logs
  - `otlp` para traces (Tempo)
  - `logging` no inicio para validacao

Principio de agnosticidade APM:
- A instrumentacao das apps nao depende do vendor.
- A troca de backend ocorre no OTel Collector (config de exporters), sem alterar codigo da aplicacao.
- Backends possiveis: stack self-hosted (Prometheus/Loki/Tempo), Grafana Cloud, Datadog, New Relic, Elastic.

Objetivos iniciais de telemetria:
- 100% das requisicoes HTTP com trace
- Correlacao logs-traces habilitada
- Dashboard com latencia p50/p95/p99, taxa de erro e throughput
- Alertas baseados em SLO

## 8. Seguranca e confiabilidade
- Policy as code com Kyverno (bloquear latest tag, exigir probes/limits).
- Scan de imagens com Trivy no CI.
- Secrets fora de texto puro (Sealed Secrets ou SOPS).
- mTLS entre servicos via Istio (strict mode no namespace da app).
- AuthorizationPolicy e RequestAuthentication para controle de acesso leste-oeste.
- Health checks obrigatorios (liveness/readiness/startup).
- Requests/limits em todos os workloads.
- Backups de configuracao (export de manifests e dashboards).

## 9. Blueprint de Service Mesh (Istio)
Capacidades minimas:
- Sidecar injection nos servicos da aplicacao.
- mTLS habilitado entre servicos internos.
- `VirtualService` e `DestinationRule` para roteamento e canary basico.
- `PeerAuthentication`, `RequestAuthentication` e `AuthorizationPolicy`.
- Metricas de malha exportadas via OTel e correlacionadas com traces.

Objetivos iniciais:
- 100% do trafego interno passando pelo mesh.
- Pelo menos 1 release canario controlado por regra de roteamento.
- Dashboards com latencia e erros por workload/servico no mesh.

## 10. Integracao Kind + AWS low-cost
Objetivo:
- Integrar componentes cloud com baixo custo para praticar cenarios reais de plataforma.

Integracoes recomendadas (ordem sugerida):
1. ECR (baixo custo): armazenar imagens do CI e puxar no kind com secret docker-registry.
2. SQS (free tier): fila real para worker assicrono.
3. DynamoDB On-Demand (free tier inicial): estado e deduplicacao com custo previsivel.
4. Lambda (free tier): jobs event-driven (ex: pre-processamento, fan-out, limpeza).

Padrao de observabilidade:
- Observabilidade centralizada em OpenTelemetry (vendor-neutral).
- Backend padrao: stack self-hosted no kind (Prometheus + Grafana + Loki + Tempo).
- Para componentes AWS, exportar metricas/logs/traces via OTel Collector.

Guardrails financeiros:
- Usar 1 regiao e naming padrao por ambiente.
- Ativar AWS Budgets com alerta baixo (exemplo: USD 5 e USD 10).
- Definir tags obrigatorias: `project=kindops-lab`, `env=dev`, `owner=<seu_nome>`.
- Preferir on-demand pequeno e destruir recursos efemeros ao fim de testes.

## 11. SRE operacional (obrigatorio no projeto)
- Definir 2 SLIs por servico:
  - Disponibilidade
  - Latencia
- Definir SLO mensal (exemplo):
  - Disponibilidade >= 99.5%
  - p95 latencia <= 300ms
- Criar runbooks para:
  - aumento de erro 5xx
  - fila crescendo
  - pod reiniciando em loop
- Fazer 1 game day por mes com simulacao de falha.
- Executar experimentos de caos com LitmusChaos (ex.: pod-delete, cpu-hog, network-latency).
- Executar teste de carga recorrente com K6 (baseline semanal).
- Monitorar custo por namespace/workload com OpenCost e revisar anomalias semanalmente.
- Aplicar IA no Grafana para correlacionar Prometheus, Loki e Tempo em incidentes criticos.

## 12. Definition of Done (DoD) do projeto
- CI/CD ponta a ponta funcionando via PR ate deploy no kind para `app-python` e `app-java`.
- Telemetria OTel com traces, metricas e logs correlacionados.
- Stack de observabilidade self-hosted operando no kind com configuracao manual.
- Service mesh Istio ativo com mTLS e roteamento canario basico.
- Integracao com pelo menos 2 servicos AWS low-cost (ex: ECR + SQS).
- Dashboards e alertas operacionais ativos.
- Dashboards de FinOps ativos (OpenCost) com custo por namespace, deployment e label.
- Suite K6 com cenarios `smoke`, `load` e `stress` + thresholds definidos.
- Suite de chaos com LitmusChaos aplicada em ambiente `dev-local` com evidencias e rollback.
- Fluxo de troubleshooting com IA no Grafana validado para metricas/logs/traces.
- Pelo menos 3 incidentes simulados com postmortem documentado.
- Documentacao reproducivel para subir tudo do zero.
