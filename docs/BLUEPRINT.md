# Blueprint: Plataforma DevOps/SRE em Kind

## 1. Objetivo
Construir um ambiente local de engenharia de plataforma para praticar CI/CD, GitOps, IaC, observabilidade e operação SRE com ferramentas open source.

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

## 2. Escopo funcional do laboratório
- Duas aplicações de referência com deploy em Kubernetes:
  - `app-python` (FastAPI + worker)
  - `app-java` (Spring Boot)
- Pipeline CI no Jenkins com testes, build de imagem, scan e push.
- CD GitOps com Argo CD observando repositório de manifests/Helm values.
- Service mesh com Istio para tráfego, segurança mTLS e políticas de roteamento.
- Provisionamento e configuração por código (Terraform + Ansible).
- Observabilidade completa:
  - Coleta e padronização com OpenTelemetry (SDK + Collector)
  - Metricas, logs e traces enviados para stack self-hosted no kind
  - Prometheus + Grafana + Loki + Tempo com configuração manual
  - Visibilidade de custo por namespace/workload com OpenCost (FinOps)
- Práticas SRE:
  - SLI/SLO e error budget
  - Chaos engineering para validação de resiliência
  - Análise assistida por IA no Grafana para acelerar troubleshooting
  - Runbooks
  - Simulação de incidentes e rollback

## 3. Arquitetura alvo
Fluxo de mudança:
1. Desenvolvedor abre PR no GitHub.
2. Jenkins executa CI (lint, testes, cobertura, scan de segurança).
3. Jenkins publica imagem versionada e atualiza artefato GitOps (chart/tag).
4. Argo CD detecta mudança e sincroniza ambiente no kind.
5. OTel Collector recebe telemetria da app e exporta:
   - Prometheus remote write / scrape endpoint para métricas
   - Loki para logs
   - Tempo para traces
6. Grafana consolida paineis e alertas.

Fluxo de runtime:
1. Usuario chama `app-python` ou `app-java`.
2. As aplicações geram spans, logs estruturados e métricas.
3. `app-python-worker` processa fila e gera spans encadeados (trace distribuído).
4. Alertmanager envia alertas quando SLO/erro/latência degradam.

## 4. Estrutura de repositórios (modelo recomendado)
Opcao A (monorepo):
- `apps/` código das aplicações
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
- `sample-app` (aplicação)

Para projeto pessoal, começar por monorepo simplifica.

## 5. Ambientes
- `dev-local`: unico cluster kind com namespaces separados por contexto:
  - `cicd` (Jenkins)
  - `argocd`
  - `observability`
  - `istio-system`
  - `apps`
- Evolução opcional:
  - `staging-local` (segundo cluster kind)
  - Política de promoção manual entre ambientes

## 6. Modelo de entrega (GitOps + CI)
- Branches:
  - `main`: estado desejado pronto para deploy
  - `feature/*`: desenvolvimento
- CI no PR:
  - lint + testes + SAST/dependencies + scan da imagem + smoke de carga com K6 (para Python e Java)
- CI no merge:
  - build final + push de 2 imagens + atualizacao de tags no repositório GitOps
- CD:
  - Argo CD sincroniza automático em `dev-local` para `app-python` e `app-java`
  - rollback via Git revert
  - Subtopico: Canary deployment + auto rollback por métrica.
  - Argo Rollouts para estratégia canary progressiva.
  - `AnalysisTemplate` com métricas de erro/latência (Prometheus).
  - Rollback automático quando threshold de métrica for violado.

Padroes de containerizacao (Docker):
- Multi-stage builds obrigatorio para reduzir imagem final.
- `HEALTHCHECK` no Dockerfile para validação básica de liveness da imagem.
- Otimizacao de camadas para melhorar cache e reduzir tempo de build.

## 7. Blueprint de OpenTelemetry
Instrumentacao mínima:
- App Python e App Java:
  - traces HTTP de entrada/saida
  - métricas RED (rate, errors, duration)
  - logs estruturados com `trace_id` e `span_id`
- Worker Python:
  - spans de consumo e processamento
  - propagacao de contexto de trace via fila/mensagem
  - métricas de throughput e falhas

Padrão de atributos:
- `service.name`, `service.version`, `deployment.environment`
- `http.method`, `http.route`, `http.status_code`
- `messaging.system`, `messaging.operation`, `messaging.destination`

OTel Collector (pipelines):
- Recepcao: OTLP gRPC/HTTP
- Processadores: `batch`, `memory_limiter`, `resource`, `attributes`
- Exportadores:
  - `prometheus`/`prometheusremotewrite` para métricas
  - `loki` para logs
  - `otlp` para traces (Tempo)
  - `logging` no início para validação

Principio de agnosticidade APM:
- A instrumentacao das apps não depende do vendor.
- A troca de backend ocorre no OTel Collector (config de exporters), sem alterar código da aplicação.
- Backends possíveis: stack self-hosted (Prometheus/Loki/Tempo), Grafana Cloud, Datadog, New Relic, Elastic.

Objetivos iniciais de telemetria:
- 100% das requisições HTTP com trace
- Correlacao logs-traces habilitada
- Dashboard com latência p50/p95/p99, taxa de erro e throughput
- Alertas baseados em SLO

## 8. Segurança e confiabilidade
- Policy as code com Kyverno (bloquear latest tag, exigir probes/limits).
- Scan de imagens com Trivy no CI.
- Secrets fora de texto puro (Sealed Secrets ou SOPS).
- mTLS entre serviços via Istio (strict mode no namespace da app).
- AuthorizationPolicy e RequestAuthentication para controle de acesso leste-oeste.
- Health checks obrigatorios (liveness/readiness/startup).
- Requests/limits em todos os workloads.
- Backups de configuração (export de manifests e dashboards).

## 9. Blueprint de Service Mesh (Istio)
Capacidades minimas:
- Sidecar injection nos serviços da aplicação.
- mTLS habilitado entre serviços internos.
- `VirtualService` e `DestinationRule` para roteamento e canary básico.
- `PeerAuthentication`, `RequestAuthentication` e `AuthorizationPolicy`.
- Metricas de malha exportadas via OTel e correlacionadas com traces.

Objetivos iniciais:
- 100% do tráfego interno passando pelo mesh.
- Pelo menos 1 release canario controlado por regra de roteamento.
- Dashboards com latência e erros por workload/serviço no mesh.

## 10. Integração Kind + AWS low-cost
Objetivo:
- Integrar componentes cloud com baixo custo para praticar cenários reais de plataforma.

Integracoes recomendadas (ordem sugerida):
1. ECR (baixo custo): armazenar imagens do CI e puxar no kind com secret docker-registry.
2. SQS (free tier): fila real para worker assíncrono.
3. DynamoDB On-Demand (free tier inicial): estado e deduplicação com custo previsivel.
4. Lambda (free tier): jobs event-driven (ex: pre-processamento, fan-out, limpeza).

Padrão de observabilidade:
- Observabilidade centralizada em OpenTelemetry (vendor-neutral).
- Backend padrão: stack self-hosted no kind (Prometheus + Grafana + Loki + Tempo).
- Para componentes AWS, exportar métricas/logs/traces via OTel Collector.

Guardrails financeiros:
- Usar 1 regiao e naming padrão por ambiente.
- Ativar AWS Budgets com alerta baixo (exemplo: USD 5 e USD 10).
- Definir tags obrigatorias: `project=kindops-lab`, `env=dev`, `owner=<seu_nome>`.
- Preferir on-demand pequeno e destruir recursos efemeros ao fim de testes.

## 11. SRE operacional (obrigatorio no projeto)
- Definir 2 SLIs por serviço:
  - Disponibilidade
  - Latência
- Definir SLO mensal (exemplo):
  - Disponibilidade >= 99.5%
  - p95 latência <= 300ms
- Criar runbooks para:
  - aumento de erro 5xx
  - fila crescendo
  - pod reiniciando em loop
- Fazer 1 game day por mes com simulação de falha.
- Executar experimentos de caos com LitmusChaos (ex.: pod-delete, cpu-hog, network-latency).
- Executar teste de carga recorrente com K6 (baseline semanal).
- Monitorar custo por namespace/workload com OpenCost e revisar anomalias semanalmente.
- Aplicar IA no Grafana para correlacionar Prometheus, Loki e Tempo em incidentes críticos.

## 12. Definition of Done (DoD) do projeto
- CI/CD ponta a ponta funcionando via PR ate deploy no kind para `app-python` e `app-java`.
- Telemetria OTel com traces, métricas e logs correlacionados.
- Stack de observabilidade self-hosted operando no kind com configuração manual.
- Service mesh Istio ativo com mTLS e roteamento canario básico.
- Integração com pelo menos 2 serviços AWS low-cost (ex: ECR + SQS).
- Dashboards e alertas operacionais ativos.
- Dashboards de FinOps ativos (OpenCost) com custo por namespace, deployment e label.
- Suite K6 com cenários `smoke`, `load` e `stress` + thresholds definidos.
- Suite de chaos com LitmusChaos aplicada em ambiente `dev-local` com evidências e rollback.
- Fluxo de troubleshooting com IA no Grafana validado para métricas/logs/traces.
- Pelo menos 3 incidentes simulados com postmortem documentado.
- Documentação reproducivel para subir tudo do zero.
