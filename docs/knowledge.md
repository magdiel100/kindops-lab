# Knowledge Base - kindops-lab

## Objetivo
Centralizar aprendizado técnico do projeto para estudo contínuo e retomada rápida.

## Como usar este arquivo
- Registre cada sessão de estudo com data.
- Explique com palavras próprias: o que e, para que serve e como usar.
- Documente decisões e trade-offs.
- Relacione erros, causa raiz e correção.
- Deixe links para arquivos do projeto e documentação oficial.

## Estrutura recomendada por entrada
### [AAAA-MM-DD] Tema
- Contexto:
- Conceitos-chave:
- O que é:
- Para que serve:
- Como usar no kindops-lab:
- Decisão tomada:
- Trade-offs:
- Comandos testados:
- Resultado observado:
- Erros encontrados:
- Correção aplicada:
- Evidências (arquivos/prints):
- Próximo passo:

### [2026-02-26] Fase 0 - Fundação e padrões
**Contexto:**  
Início oficial do projeto com foco em base organizacional, padrões de contribuição e estrutura mínima para escalar sem retrabalho.

**Conceitos-chave:**
- **Scaffold de repositório**
  - Esqueleto inicial do projeto com pastas, arquivos base e convenções minimas para começar com organização.
  - Exemplos no projeto: `apps/`, `infra/`, `docs/`, `README.md`, `Makefile`.
- **Templates de PR/Issue**
  - Formulários padrão para abrir Pull Requests e Issues no GitHub.
  - Forçam informação mínima útil (objetivo, impacto, testes, evidências), melhorando revisão e rastreabilidade.
- **Bootstrap automatizado**
  - Comando/script para preparar a base do projeto automaticamente, evitando criação manual repetitiva.
  - Exemplo no projeto: `make bootstrap` para criar diretórios e arquivos iniciais de forma padronizada.
- **Padronização de fluxo e Definition of Done da fase**

**O que é:**  
Fase de preparação estrutural do projeto antes de implementar infraestrutura e workloads.

**Para que serve:**  
Reduzir improviso, garantir consistência de contribuições e facilitar retomada do projeto em qualquer momento.

**Como usar no kindops-lab:**  
Executar bootstrap para garantir estrutura mínima, seguir `CONTRIBUTING.md` em toda mudança e abrir PR/Issues com template.

**Decisão tomada:**  
Criar estrutura base completa + arquivos de governança (`README`, `Makefile`, templates e guia de contribuição) antes da Fase 1.

**Trade-offs:**  
Investimento inicial em documentação e organização atrasou a parte técnica de deploy, mas reduz risco de desorganizacao nas fases seguintes.

**Comandos testados:**
- `find /mnt/c/Users/magdi/Documents/projetos/kindops-lab -maxdepth 3 -type d | sort`
- `find /mnt/c/Users/magdi/Documents/projetos/kindops-lab -maxdepth 3 -type f | sort`
- `cd /mnt/c/Users/magdi/Documents/projetos/kindops-lab && make bootstrap`
- `cd /mnt/c/Users/magdi/Documents/projetos/kindops-lab && mkdir -p apps infra/terraform infra/ansible charts gitops observability .github/ISSUE_TEMPLATE docs`

**Resultado observado:**
- Estrutura de diretórios da Fase 0 criada com sucesso.
- `Makefile` criado com alvo `bootstrap`.
- Templates de PR/Issue e guia de contribuição adicionados.
- README com pre-requisitos, estrutura e início rápido criado.

**Erros encontrados:**  
`make: command not found` no ambiente atual.

**Correção aplicada:**  
Estrutura criada manualmente com `mkdir -p` para não bloquear progresso; `Makefile` mantido para uso quando `make` estiver disponível.

**Evidências (arquivos/prints):**
- `README.md`
- `Makefile`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/bug_report.md`
- `.github/ISSUE_TEMPLATE/feature_request.md`
- `docs/CONTRIBUTING.md`
- Diretórios: `apps/`, `infra/terraform/`, `infra/ansible/`, `charts/`, `gitops/`, `observability/`, `docs/`

**Próximo passo:**  
Iniciar Fase 1 com bootstrap técnico do ambiente local (kind + helm + base de observabilidade) e registrar cada sessão neste documento.

### [2026-02-27] Fase 0.5 - GitHub (criação de repositório e sincronização)
**Contexto:**  
Necessidade de publicar o projeto `kindops-lab` no GitHub para habilitar fluxo GitOps/CI com histórico rastreável.

**Conceitos-chave:**
- **Remoto `origin`**
  - Referência local para o repositório remoto no GitHub.
- **Push inicial**
  - Envio da branch local `main` para criar/atualizar `origin/main`.
- **Tracking branch**
  - Relação entre branch local e branch remota para facilitar `pull`/`push`.
- **Branch `main`**
  - Branch principal e estável do projeto.
  - Deve representar o estado oficial do código.
  - Idealmente recebe mudanças via PR aprovado.
- **Branches `feature/*`**
  - Branches temporárias para desenvolvimento isolado de funcionalidades.
  - Exemplo: `feature/fase-1-bootstrap-local`.
  - Evitam impacto direto na `main` durante implementação.
- **`origin/main`**
  - Referência da branch `main` no remoto (GitHub).
  - A branch `main` local deve ficar sincronizada com `origin/main`.

**O que é:**  
Processo de conectar repositório local ao GitHub, autenticar, criar o repositório remoto e sincronizar a branch principal.

**Para que serve:**  
Garantir backup remoto, colaboração via PR, integração com ferramentas de CI/CD e rastreabilidade de mudanças.

**Como usar no kindops-lab:**  
Manter `main` sincronizada com `origin/main`, criar mudanças em `feature/*` e integrar via PR.

**Decisão tomada:**  
Criar o repositório no GitHub via interface web e usar push via HTTPS com autenticação por browser.

**Trade-offs:**  
Fluxo web e simples, mas pode gerar erro `repository not found` se o repo remoto ainda não existir.

**Comandos testados:**
- `git init` -> inicializa o repositório Git local na pasta do projeto.
- `git add .` -> adiciona todas as alterações da pasta atual para a área de staging.
- `git commit -m "mensagem"` -> cria um commit com os arquivos staged e registra um ponto da mudança no histórico.
- `git remote -v` -> lista os repositórios remotos configurados (`fetch` e `push`).
- `git status` -> mostra estado atual da branch e se há arquivos pendentes para commit.
- `git branch -vv` -> lista branches locais com info de tracking remoto e último commit.
- `git log --oneline -n 3` -> mostra os 3 commits mais recentes em formato resumido.
- `git remote set-url origin https://github.com/magdiel100/kindops-lab.git` -> atualiza a URL do remoto `origin`.
- `git push -u origin main` -> envia a branch `main` para o remoto e define rastreamento (`upstream`).

**Resultado observado:**
- `origin` configurado para `https://github.com/magdiel100/kindops-lab.git`.
- Push concluído com sucesso: `main -> main`.
- Branch local configurada para rastrear `origin/main`.
- Working tree limpa após sincronização.

**Erros encontrados:**
- `remote: Repository not found.`
- `fatal: repository 'https://github.com/magdiel100/kindops-lab.git/' not found`
- `bash: ]: command not found` (erro de digitação)

**Correção aplicada:**
- Criação do repositório remoto no GitHub com nome exato `kindops-lab`.
- Nova tentativa de push após autenticação no browser.
- Ignorado o erro de `]` por não ser erro do Git.

**Evidências (arquivos/prints):**
- URL do remoto: `https://github.com/magdiel100/kindops-lab.git`
- Mensagem de push: `branch 'main' set up to track 'origin/main'`
- Validação: `On branch main` e `nothing to commit, working tree clean`

**Próximo passo:**  
Criar branch de trabalho da Fase 1 (`feature/fase-1-bootstrap-local`) e iniciar bootstrap técnico do ambiente.

### [2026-02-28] Fase 1 - Bootstrap local (início)
**Contexto:**  
Início da Fase 1 para preparar bootstrap do host, configuração versionada do kind e scripts operacionais de ciclo de vida do cluster.

**Conceitos-chave:**
- **Bootstrap do host com Ansible**
  - Padroniza preparação da máquina local para evitar setup manual.
- **Cluster como configuração versionada**
  - Define topologia do kind via arquivo (`infra/kind/kind-config.yaml`) para reprodutibilidade.
- **Ciclo de vida do ambiente**
  - Scripts dedicados para criar, destruir e recriar o cluster com o mesmo padrão.

**O que é:**  
Implementação da base operacional da Fase 1 (estrutura, automação e documentação).

**Para que serve:**  
Permitir subir e resetar o laboratório local de forma consistente e rastreável.

**Como usar no kindops-lab:**  
- `make ansible-bootstrap` para preparar host local.
- `make bootstrap-kind` para subir cluster, namespaces e ingress.
- `make destroy-kind` para remover cluster.
- `make recreate-kind` para teste de reconstrução.

**Aplicação dos scripts (Ansible + scripts operacionais):**
- **Ansible (`infra/ansible/`)**
  - `ansible.cfg`: define inventário padrão, roles path e uso de `sudo`.
  - `inventory/hosts.ini`: alvo local (`localhost`) para execução no próprio host.
  - `group_vars/all.yml`: controla o que instalar (`install_*`) e versões alvo.
  - `playbooks/bootstrap-host.yml`: orquestra as roles `common`, `docker`, `kubectl`, `kind` e `helm`.
  - `roles/common/tasks/main.yml`: valida Linux/WSL e instala dependências base.
  - `roles/docker/tasks/main.yml`: verifica Docker e instala `docker.io` somente se habilitado.
  - `roles/kubectl/tasks/main.yml`: instala `kubectl` se ausente.
  - `roles/kind/tasks/main.yml`: instala `kind` se ausente.
  - `roles/helm/tasks/main.yml`: instala `helm` se ausente.
- **Scripts operacionais (`scripts/`)**
  - `bootstrap-kind.sh`: valida pré-requisitos, cria cluster, aplica limites de recursos nos nós, cria namespaces base e instala ingress-nginx.
  - `destroy-kind.sh`: remove o cluster `kindops-lab`.
  - `recreate-kind.sh`: executa `destroy` + `bootstrap` para reconstrução do zero.

**Ordem recomendada de execução:**
1. `make ansible-bootstrap`
2. `make bootstrap-kind`
3. `kubectl get nodes`
4. `kubectl get ns`
5. `kubectl -n ingress-nginx get pods`
6. `make recreate-kind` (teste de reprodutibilidade)

**Decisão tomada:**  
Criar playbook único (`bootstrap-host.yml`) com roles separadas por ferramenta (`docker`, `kubectl`, `kind`, `helm`) e scripts shell para operação do cluster.

**Trade-offs:**  
As roles estão focadas em Linux/WSL e simplicidade inicial. Para produção, será necessário adicionar suporte multi-OS e validações mais rígidas.

**Comandos testados:**
- `bash -n scripts/bootstrap-kind.sh scripts/destroy-kind.sh scripts/recreate-kind.sh` -> valida sintaxe dos scripts shell.
- `ansible-playbook --version` -> valida disponibilidade do Ansible no host.
- `for c in docker kubectl kind helm; do ...; done` -> verifica se os binários estão disponíveis no PATH.
- `cat /etc/os-release` -> valida ambiente Ubuntu/WSL.
- `which apt` -> valida presença do gerenciador de pacotes.
- `sudo apt update && sudo apt install -y make ansible` -> instala pré-requisitos de automação.
- `make ansible-bootstrap` -> executa bootstrap do host via Ansible.
- `kind version` e `helm version --short` -> valida instalação das ferramentas faltantes.

**Resultado observado:**
- Estrutura criada:
  - `infra/ansible/ansible.cfg`
  - `infra/ansible/inventory/hosts.ini`
  - `infra/ansible/group_vars/all.yml`
  - `infra/ansible/playbooks/bootstrap-host.yml`
  - `infra/ansible/roles/{common,docker,kubectl,kind,helm}/tasks/main.yml`
  - `infra/kind/kind-config.yaml`
  - `scripts/bootstrap-kind.sh`
  - `scripts/destroy-kind.sh`
  - `scripts/recreate-kind.sh`
- Sintaxe dos scripts shell validada com sucesso.
- `docker` encontrado no ambiente atual.

**Erros encontrados:**
- `ansible-playbook: command not found`
- `kubectl`, `kind` e `helm` não encontrados no PATH do ambiente executado.
- `make: command not found` ao tentar executar targets do projeto.
- `ansible-playbook: error: unrecognized arguments: --roles-path`.
- `install_docker is undefined` durante avaliação de condição no playbook.
- Warning recorrente: Ansible ignorando `ansible.cfg` em diretório world-writable (`/mnt/c/...`).

**Correção aplicada:**
- Mantido fluxo de bootstrap versionado e idempotente.
- Execução movida para WSL Ubuntu (com `apt` disponível).
- Instalação de `make` e `ansible` no host WSL.
- Ajuste do `Makefile` para usar:
  - `ANSIBLE_ROLES_PATH=roles` (compatível com versão atual do Ansible).
  - `-e @group_vars/all.yml` para carregar variáveis explicitamente quando `ansible.cfg` é ignorado.
- `group_vars/all.yml` ajustado para `install_docker: false` (uso de Docker Desktop).
- Resultado: `make ansible-bootstrap` concluído com sucesso; `kind` e `helm` instalados e validados.

**Evidências (arquivos/prints):**
- `infra/ansible/README.md`
- `infra/kind/kind-config.yaml`
- `scripts/bootstrap-kind.sh`
- `scripts/destroy-kind.sh`
- `scripts/recreate-kind.sh`
- `Makefile` (ajustes no target `ansible-bootstrap`)
- `infra/ansible/group_vars/all.yml` (Docker Desktop: `install_docker: false`)
- `docs/runbooks.md` (RB-001 atualizado)
- `docs/roadmap.md` (checklist da Fase 1 atualizado parcialmente)

**Próximo passo:**  
Executar no host local: `make bootstrap-kind`, validar nós/namespaces/ingress, executar `make recreate-kind` e então fechar os itens pendentes da Fase 1.

**Ajustes e correções executados (resumo didático):**
1. Ambiente correto definido:
   - Problema: comandos `apt` e `make` falhavam fora do WSL.
   - Ação: execução padronizada no Ubuntu WSL (`/mnt/c/...`).
2. Bootstrap Ansible estabilizado para `/mnt/c`:
   - Problema: `ansible.cfg` ignorado por permissão world-writable.
   - Ação: `Makefile` passou a informar inventário, roles path e variáveis explicitamente no comando.
3. Compatibilidade com versão do Ansible:
   - Problema: opção `--roles-path` não suportada no binário instalado.
   - Ação: troca para `ANSIBLE_ROLES_PATH=roles`.
4. Estratégia Docker alinhada ao cenário real:
   - Problema: projeto inicialmente previa instalar `docker.io`.
   - Ação: `install_docker: false` para manter Docker Desktop como runtime.
5. Resultado técnico:
   - `make ansible-bootstrap` finalizou sem erro.
   - `kind` e `helm` instalados (`kind v0.23.0`, `helm v3.15.4`).

**Execução prática do bootstrap-kind (resultado validado):**
- Comando executado:
  - `make destroy-kind`
  - `make bootstrap-kind`
- Versões validadas em runtime:
  - Docker `28.3.2`
  - kubectl `v1.32.2`
  - kind `v0.23.0`
  - helm `v3.15.4`
- Estado do cluster:
  - `kindops-lab-control-plane` e `kindops-lab-worker` em `Ready`.
- Namespaces base:
  - `cicd`, `argocd`, `observability`, `istio-system`, `apps` criados e `Active`.
- Ingress:
  - release `ingress-nginx` instalada via Helm.
  - pod do controller validado em `Running`.

**Incidentes durante execução e correções aplicadas:**
1. Erro de limite de memória no `docker update`:
   - Erro: `Memory limit should be smaller than already set memoryswap limit`.
   - Causa: atualização de `--memory` sem atualizar `--memory-swap`.
   - Correção: script ajustado para enviar `--memory` e `--memory-swap` juntos nos nós do kind.
2. Timeout transitório do API server ao criar namespace:
   - Erro: `etcdserver: request timed out`.
   - Causa: API ainda estabilizando logo após criação do cluster.
   - Correção: adicionados `wait/retry` no `bootstrap-kind.sh` (checagem `/readyz` + retry em comandos `kubectl` críticos).
   - Resultado: segunda execução completou bootstrap sem falhas.
3. Falha intermitente no `make recreate-kind` durante `kubeadm init`:
   - Erro: timeout na fase de addon DNS (`unable to fetch CoreDNS current installed version and ConfigMap`).
   - Causa: instabilidade transitória de inicialização do control-plane em ambiente com recurso limitado.
   - Correção: adicionada rotina de retry para criação do cluster no `bootstrap-kind.sh` (`KIND_CREATE_RETRIES`), com limpeza de tentativa parcial entre execuções.
   - Resultado esperado: maior resiliência no teste de reprodutibilidade (destroy + create).

**Validação do teste de reprodutibilidade (Fase 1):**
- Comandos executados:
  - `make recreate-kind`
  - `kubectl get nodes`
  - `kubectl get ns`
  - `kubectl -n ingress-nginx get pods`
- Resultado:
  - Cluster recriado com sucesso na tentativa `1/3`.
  - Nodes em `Ready` (`control-plane` e `worker`).
  - Namespaces base criados e `Active`.
  - Ingress instalado com release `deployed`.
  - No instante da validação final, pod do ingress ainda em `ContainerCreating` (estado transitório comum logo após instalação).
- Conclusão:
  - Critério de reprodutibilidade da Fase 1 atendido (destroy + recreate funcionando de ponta a ponta).

### [2026-03-03] Fase 2 - CI com Jenkins (inicio)
**Contexto:**  
Inicio da Fase 2 para preparar CI com Jenkins no cluster local, com pipelines declarativas para `app-python` e `app-java`.

**Conceitos-chave:**
- **Jenkins via Helm no kind**
  - Instalacao reproduzivel com `helm upgrade --install` no namespace `cicd`.
- **Pipeline declarativa por aplicacao**
  - Cada app possui `Jenkinsfile` proprio com estagios padrao de CI.
- **Container hardening basico**
  - Dockerfiles multi-stage com `HEALTHCHECK` e usuario nao-root.

**O que e:**  
Primeira entrega tecnica da Fase 2: estrutura de apps, pipelines, Dockerfiles e automacao de instalacao do Jenkins.

**Para que serve:**  
Sair do estado apenas documental para um fluxo CI executavel e versionado no repositorio.

**Como usar no kindops-lab:**
- Instalar Jenkins:
  - `make install-jenkins`
- Expor Jenkins localmente:
  - `make jenkins-port-forward`
- Pipelines declarativas:
  - `apps/app-python/Jenkinsfile`
  - `apps/app-java/Jenkinsfile`

**Decisao tomada:**  
Comecar com duas apps minimas (FastAPI e Spring Boot) para validar esteira de CI completa antes de sofisticar arquitetura dos servicos.

**Trade-offs:**  
- Vantagem: entrega rapida de pipeline end-to-end e base para evolucao.
- Custo: cobertura de testes ainda inicial e sem publicacao real em registry ate configurar credenciais/host no Jenkins.
- Decisao de escopo: na Fase 2, usar registry local para reduzir atrito e fechar o CI; integracao com ECR fica reservada para a Fase 8, onde AWS entra como parte formal da arquitetura.

**Comandos testados:**
- `wsl chmod +x /mnt/c/Users/magdi/Documents/projetos/kindops-lab/scripts/install-jenkins.sh /mnt/c/Users/magdi/Documents/projetos/kindops-lab/scripts/jenkins-port-forward.sh`

**Resultado observado:**
- Estrutura criada para Fase 2:
  - `infra/jenkins/values.yaml`
  - `scripts/install-jenkins.sh`
  - `scripts/jenkins-port-forward.sh`
  - `apps/app-python/*` (app, testes, Dockerfile, Jenkinsfile, k6)
  - `apps/app-java/*` (Spring Boot, testes, Dockerfile, Jenkinsfile, k6)
- `Makefile` atualizado com `install-jenkins`, `jenkins-port-forward`, `phase2-check`.

**Erros encontrados:**
- Timeout ao tentar `chmod` com invocacao inicial via bash.

**Correcao aplicada:**
- Ajuste para execucao explicita via `wsl chmod ...`.

**Evidencias (arquivos/prints):**
- `apps/app-python/Jenkinsfile`
- `apps/app-java/Jenkinsfile`
- `infra/jenkins/values.yaml`
- `scripts/install-jenkins.sh`
- `scripts/jenkins-port-forward.sh`
- `docs/runbooks.md` (RB-009)

**Proximo passo:**  
Executar instalacao real do Jenkins no cluster (`make install-jenkins`), criar jobs para os dois Jenkinsfiles e validar pipeline end-to-end com registry configurado.

**Atualizacao operacional (2026-03-03 - instalacao real Jenkins):**
- Jenkins instalado no namespace `cicd` e pod `jenkins-0` estabilizado em `2/2 Running`.
- Causa raiz do erro inicial no init container:
  - conflito de versao de plugins (`configuration-as-code` e `credentials-binding`) no `infra/jenkins/values.yaml`.
  - falhas temporarias `503` no download de plugins pelo `updates.jenkins.io`.
- Correcao aplicada:
  - atualizacao das versoes de plugins no `values.yaml`.
  - script `install-jenkins.sh` com diagnostico automatico em falhas de rollout.
- Acesso web:
  - porta local `8080` estava ocupada.
  - `jenkins-port-forward.sh` ajustado para usar `18080` por default.
  - acesso validado em `http://127.0.0.1:18080`.
- Credencial admin:
  - usuario admin mantido.
  - senha admin alterada manualmente no Jenkins (nao depender do valor inicial do secret apos alteracao manual).

### [2026-03-18] Fase 2 - Registry local no Jenkins (integracao e finalidade)
**Contexto:**  
Fechamento da parte de registry da Fase 2 sem dependencias AWS, mantendo ECR como evolucao da Fase 8.

**Conceitos-chave:**
- **Registry local (`registry:2`)**
  - Registry interno para validar `docker tag` e `docker push` no CI sem acoplamento cloud.
- **Acesso do Jenkins no kind ao host**
  - Como Jenkins roda no cluster kind, `localhost` no pipeline nao aponta para o host da maquina.
  - Host validado para este laboratorio: `host.docker.internal:5000`.
- **Autenticacao opcional por variavel**
  - Pipelines ajustadas para suportar dois modos:
    - local sem auth (`REGISTRY_AUTH_REQUIRED=false`)
    - registry com auth futura (`REGISTRY_AUTH_REQUIRED=true` + `registry-creds`)

**O que e:**  
Implementacao da integracao com registry local para concluir os itens pendentes de CI da Fase 2.

**Para que serve:**  
Permitir validar push de imagem no pipeline agora, sem bloquear o roadmap por configuracao AWS antecipada.

**Como usar no kindops-lab:**
- Subir o registry local:
  - `docker run -d --restart=always -p 5000:5000 --name registry-local registry:2`
- Validar API do registry:
  - `curl -i http://localhost:5000/v2/`
- Validar conectividade a partir dos nos kind:
  - `docker exec kindops-lab-control-plane sh -lc "curl -fsS http://host.docker.internal:5000/v2/"`
  - `docker exec kindops-lab-worker sh -lc "curl -fsS http://host.docker.internal:5000/v2/"`
- Configurar variaveis dos jobs Jenkins:
  - `REGISTRY_HOST=host.docker.internal:5000`
  - `REGISTRY_AUTH_REQUIRED=false`

**Decisao tomada:**  
Usar registry local na Fase 2 para validar CI end-to-end com menor atrito, mantendo migracao para ECR na Fase 8.

**Trade-offs:**  
- Vantagem: ciclo de validacao rapido e sem dependencia de IAM/ECR.
- Custo: imagens ficam em registry local (escopo de laboratorio), sem cobertura cloud nesta fase.
- Mitigacao: pipelines ja deixadas compativeis com autenticacao futura via `registry-creds`.

**Comandos testados:**
- `docker ps`
- `docker logs registry-local`
- `curl -i http://localhost:5000/v2/`
- `kubectl -n cicd get pods -o wide`
- `docker exec kindops-lab-control-plane sh -lc "(curl -fsS http://host.docker.internal:5000/v2/ || wget -qO- http://host.docker.internal:5000/v2/)"`
- `docker exec kindops-lab-worker sh -lc "(curl -fsS http://host.docker.internal:5000/v2/ || wget -qO- http://host.docker.internal:5000/v2/)"`

**Resultado observado:**
- `registry-local` ativo e respondendo `HTTP 200` na rota `/v2/`.
- Nos do kind com conectividade valida para `host.docker.internal:5000`.
- `Jenkinsfile` de `app-python` e `app-java` atualizados para pular `docker login` quando `REGISTRY_AUTH_REQUIRED=false`.
- Runbook da Fase 2 atualizado com `REGISTRY_HOST` e `REGISTRY_AUTH_REQUIRED`.

**Erros encontrados:**
- `Invoke-WebRequest: command not found` ao executar comando PowerShell dentro do Git Bash.

**Correcao aplicada:**
- Uso de `curl` no Git Bash para validacao HTTP do registry.

**Evidencias (arquivos/prints):**
- `apps/app-python/Jenkinsfile`
- `apps/app-java/Jenkinsfile`
- `docs/runbooks.md`
- `docs/roadmap.md`
- Logs do container `registry-local` com resposta `200` para `/v2/`.

**Proximo passo:**  
Executar pipelines `app-python` e `app-java` com as variaveis do job configuradas e capturar evidencias para fechar o item de execucao end-to-end da Fase 2.

**Atualizacao operacional (2026-03-18 - fechamento end-to-end da Fase 2):**
- Execucao end-to-end concluida para `app-python` e `app-java` com os estagios:
  - lint
  - unit
  - integration
  - build
  - smoke
  - push
- Tag usada na validacao: `b6150be`.
- Evidencias objetivas do registry local:
  - `curl http://localhost:5000/v2/_catalog` -> `{"repositories":["app-java","app-python"]}`
  - `curl http://localhost:5000/v2/app-python/tags/list` -> `{"name":"app-python","tags":["b6150be"]}`
  - `curl http://localhost:5000/v2/app-java/tags/list` -> `{"name":"app-java","tags":["b6150be"]}`

**Correcoes aplicadas durante o fechamento:**
1. `app-java` - falha no teste de integracao (`500` em `/greet/{name}`):
   - Causa: binding de `@PathVariable` sem nome explicito em runtime.
   - Correcao: `@PathVariable("name")` em `HealthController.greet`.
2. `app-java` - smoke falhando por jar nao executavel:
   - Erro: `no main manifest attribute, in /app/app.jar`.
   - Causa: `spring-boot-maven-plugin` sem execucao de `repackage` no `pom.xml`.
   - Correcao: adicionar execucao `repackage` no plugin.

**Evidencias (arquivos/prints) - atualizacao de fechamento:**
- `apps/app-java/src/main/java/com/kindopslab/appjava/web/HealthController.java`
- `apps/app-java/pom.xml`
- `apps/app-python/Jenkinsfile`
- `apps/app-java/Jenkinsfile`
- `docs/roadmap.md` (item de end-to-end marcado como concluido)

**Atualizacao operacional (2026-03-18 - acesso ao portal Jenkins):**
- Endpoint oficial de acesso no laboratorio:
  - `http://127.0.0.1:18080/`
- Motivo tecnico:
  - a porta `8080` do host ja estava ocupada pelo mapeamento do control-plane do kind (`0.0.0.0:8080->80`), causando conflito para `port-forward` do Jenkins.
- Acao aplicada:
  - manter `kubectl -n cicd port-forward svc/jenkins 18080:8080` como padrao operacional.
- Resultado:
  - acesso ao Jenkins estabilizado em `127.0.0.1:18080`.

### [2026-03-20] Jenkins - Troubleshooting de startup lento do `jenkins-0`
**Contexto:**  
Pod `jenkins-0` no namespace `cicd` estava levando ~4-5 minutos para ficar `Ready` apos restart.

**Conceitos-chave:**
- **Image pull policy**
  - `Always` forcava pull em todo restart, mesmo com imagem ja presente no node.
- **Bootstrap do init container**
  - instalacao/copia de plugins no startup adiciona latencia relevante.
- **Readiness de aplicacao Java**
  - Jenkins pode ficar em `503` por alguns ciclos ate concluir carregamento de plugins/JCasC.

**O que e:**  
Analise de causa raiz e otimizacao de tempo de recuperacao do controller Jenkins apos restart.

**Para que serve:**  
Reduzir tempo de indisponibilidade em reinicios operacionais e criar referencia para troubleshooting similar.

**Como usar no kindops-lab (passo a passo):**
1. Coletar estado e eventos:
   - `kubectl -n cicd get pod jenkins-0 -o wide`
   - `kubectl -n cicd describe pod jenkins-0`
   - `kubectl -n cicd get events --sort-by=.lastTimestamp | tail -n 30`
2. Validar logs do init e controller:
   - `kubectl -n cicd logs jenkins-0 -c init --tail=200`
   - `kubectl -n cicd logs jenkins-0 -c jenkins --since=20m | tail -n 200`
3. Aplicar parametros no `infra/jenkins/values.yaml`:
   - `controller.initializeOnce: true`
   - `controller.installLatestPlugins: false`
   - `controller.image.pullPolicy: IfNotPresent`
4. Reaplicar release:
   - `./scripts/install-jenkins.sh`
5. Medir tempo real de restart:
   - `kubectl -n cicd delete pod jenkins-0`
   - `kubectl -n cicd wait --for=condition=Ready pod/jenkins-0 --timeout=900s`

**Decisao tomada:**  
Priorizar reducao de latencia sem aumentar complexidade operacional: manter imagem oficial, otimizar politica de pull e comportamento de inicializacao.

**Trade-offs:**  
- Vantagem: restart mais rapido e consistente.
- Custo: ainda existe tempo de warm-up do Jenkins (startup probes/boot Java/plugins).
- Mitigacao: para ganho adicional, usar imagem custom com plugins pre-instalados.

**Comandos testados:**
- `kubectl -n cicd describe pod jenkins-0`
- `kubectl -n cicd logs jenkins-0 -c init --tail=200`
- `kubectl -n cicd logs jenkins-0 -c jenkins --since=20m | tail -n 200`
- `./scripts/install-jenkins.sh`
- `kubectl -n cicd wait --for=condition=Ready pod/jenkins-0 --timeout=900s`

**Resultado observado:**
- Antes das otimizacoes: ~4-5 minutos para `Ready`.
- Depois das otimizacoes: `RESTART_READY_SECONDS=118` (~1m58s).
- Evento relevante apos ajuste:
  - `Container image "docker.io/jenkins/jenkins:2.541.3-jdk21" already present on machine`
  - (sem pull longo de ~1m25 observado anteriormente).

**Erros encontrados:**
- `kubectl top` indisponivel no ambiente atual:
  - `error: Metrics API not available`
- Durante analise, houve ciclo com `Startup probe failed` (`connection refused`, `503`) ate Jenkins completar bootstrap.

**Correcao aplicada:**
- Ajustes de valores no Helm:
  - `initializeOnce: true`
  - `installLatestPlugins: false`
  - `image.pullPolicy: IfNotPresent`
- Reaplicacao do release Jenkins e validacao por medicao objetiva de restart.

**Evidencias (arquivos/prints):**
- `infra/jenkins/values.yaml`
- Saida de medicao:
  - `RESTART_READY_SECONDS=118`
- Eventos do pod com imagem "already present on machine".

**Proximo passo:**  
Se necessario reduzir abaixo de ~1m30, criar imagem custom Jenkins com plugins pre-instalados e revisar compatibilidade da lista de plugins para reduzir warm-up no boot.

### [2026-03-21] Jenkins + CI + Cluster - resumo operacional do dia
**Contexto:**  
Sessao focada em estabilizacao do Jenkins, validacao guiada de pipeline via portal, ajuste do roadmap e correcoes operacionais do cluster.

**Conceitos-chave:**
- **Controller Jenkins vs executores**
  - Controller coordena jobs; nao e ideal para executar builds pesadas.
- **Drift de plugins**
  - Atualizacao manual via UI pode conflitar com versoes declaradas no Helm.
- **Metrics API no kind**
  - `kubectl top` depende de `metrics-server` saudavel e acessando kubelet corretamente.

**O que foi feito (acoes principais):**
- Ajustado `startupProbe` do Jenkins para evitar restart prematuro durante boot.
- Reaplicado release Jenkins e validado `jenkins-0` em `2/2 Running`.
- Fixada senha admin no Helm (`controller.admin.password: admin`) e validada apos restart.
- Atualizadas versoes de plugins no `values.yaml` e aplicadas via Helm:
  - `kubernetes`, `git`, `github`, `docker-workflow`.
- Validado acesso/uso do pipeline `app-python` pelo portal (SCM + branch + script path + parametros).
- Corrigido `metrics-server` no kind (erro TLS de kubelet) para habilitar `kubectl top`.
- Identificado e removido cluster nao utilizado `mycluster`.
- Atualizado `docs/roadmap.md` com o conteudo de evolucao de dominio como subtitulo interno `Fase 4.5` dentro da Fase 4.

**Problemas encontrados e causa raiz:**
1. `jenkins-0` reiniciando/instavel em startup:
   - Causa: tempo de bootstrap maior que tolerancia do probe em ciclos com plugins/JCasC.
2. Pipeline `app-python` travando/falhando:
   - Primeiro: sem executor disponivel (`Waiting for next available executor`).
   - Depois: ambiente sem `python3` no executor atual (controller).
3. `kubectl top` indisponivel:
   - Causa: `metrics-server` com `x509` no scrape do kubelet (cert sem IP SAN).
4. Recurso desnecessario no host:
   - Cluster extra `mycluster` consumindo CPU/memoria.

**Correcoes aplicadas:**
- Jenkins:
  - `controller.probes.startupProbe.failureThreshold: 40`
  - `controller.image.pullPolicy: IfNotPresent`
  - `controller.admin.password: admin`
  - Reaplicacoes via `helm upgrade --install ... --wait`.
- Plugins:
  - Atualizacao declarativa no `infra/jenkins/values.yaml`.
- Metrics:
  - Patch no deployment `metrics-server` com:
    - `--kubelet-insecure-tls`
    - `--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP`
- Limpeza:
  - `kind delete cluster --name mycluster`.

**Comandos testados (resumo):**
- `helm upgrade --install jenkins ... --wait`
- `kubectl -n cicd get/describe/logs pod jenkins-0`
- `kubectl -n cicd wait --for=condition=Ready pod/jenkins-0 --timeout=...`
- `kubectl -n kube-system logs deploy/metrics-server --tail=...`
- `kubectl -n kube-system patch deploy metrics-server --type='json' -p='...'`
- `kubectl top node`
- `kubectl top pod -n cicd`
- `kind get clusters`
- `kind delete cluster --name mycluster`

**Resultado observado:**
- Jenkins estabilizado e operacional (`jenkins-0` pronto apos restart).
- Senha admin persistindo como `admin` apos reinicializacao.
- Plugins alvo atualizados e release em estado `deployed`.
- `kubectl top` funcionando para nodes e pods.
- Apenas `kindops-lab` ativo (cluster extra removido).
- Pipeline `app-python` executa ate o stage `lint`, falhando por dependencia de runtime (`python3`) no executor atual.

**Evidencias (arquivos/prints):**
- `infra/jenkins/values.yaml`
- `docs/roadmap.md`
- Console Output do job `app-python` (erro `python3: not found`).
- Saidas de validacao:
  - `kubectl top node`
  - `kubectl top pod -n cicd`
  - `kind get clusters`

**Proximo passo:**  
Continuar validacao da Fase 2/3 com apps atuais, movendo execucao dos jobs para agent adequado (ideal: pod dinamico Kubernetes com imagem contendo runtime/ferramentas de CI).

### [2026-03-21] Evolucao Fase 2 - Jenkins com agentes dinamicos Kubernetes
**Contexto:**  
Execucao da evolucao do checklist da Fase 2 para remover dependencia do controller Jenkins como executor e preparar pipelines para pods efemeros.

**Conceitos-chave:**
- **Agente dinamico no Kubernetes**
  - O job sobe um pod efemero por build e encerra ao final.
- **PodTemplate declarativo no Jenkinsfile**
  - Infra do agente fica versionada no repositorio e nao apenas na UI.
- **Imagem base de CI**
  - Padroniza runtime/ferramentas minimas para evitar falhas como `python3: not found`.

**O que foi feito (acoes principais):**
- `apps/app-python/Jenkinsfile` atualizado de `agent any` para `agent { kubernetes { ... } }`.
- `apps/app-java/Jenkinsfile` atualizado de `agent any` para `agent { kubernetes { ... } }`.
- PodTemplate adicionado em ambos:
  - namespace de execucao `cicd` (via cloud/plugin + SA `jenkins`);
  - label dedicada por app;
  - `workspaceVolume` (`emptyDir`) em `/home/jenkins/agent`;
  - recursos (`requests/limits`);
  - mount de `/var/run/docker.sock`.
- Imagem base de agente criada em `infra/jenkins/agent/Dockerfile` com:
  - `python3`, `python3-venv`, `python3-pip`, `git`, `docker.io`, `maven`, `jdk17`.
- Script operacional criado:
  - `scripts/build-jenkins-agent.sh` (build/push para registry local).
- `Makefile` atualizado com alvo:
  - `make build-jenkins-agent`.
- Runbook de troubleshooting criado:
  - `docs/runbooks.md` -> `RB-010 - Evolucao Fase 2: agentes dinamicos Kubernetes no Jenkins`.
- Roadmap atualizado para refletir itens concluidos desta evolucao.

**Comandos executados (sessao):**
- `Get-Content`/`rg` para validar estado de Jenkinsfiles, roadmap e runbooks.
- Edicao versionada dos arquivos de pipeline, runbook, roadmap e imagem de agente.

**Resultado observado:**
- Codigo pronto para execucao em pod dinamico Kubernetes nas pipelines `app-python` e `app-java`.
- Base de agente CI padronizada e versionada para uso no cluster local.
- Documentacao operacional e status de roadmap alinhados com o que foi entregue.

**Pendencias para fechar completamente o bloco da evolucao Fase 2:**
1. Validar cloud Kubernetes no Jenkins (`Manage Jenkins > Clouds`).
2. Executar build real e comprovar pod efemero (`jenkins-agent-*`) no namespace `cicd`.
3. Registrar evidencias de console/pod/duracao no proprio `knowledge.md`.

**Evidencias (arquivos):**
- `apps/app-python/Jenkinsfile`
- `apps/app-java/Jenkinsfile`
- `infra/jenkins/agent/Dockerfile`
- `scripts/build-jenkins-agent.sh`
- `docs/runbooks.md`
- `docs/roadmap.md`

### [2026-03-21] Validacao Jenkins - plugin Kubernetes e cloud local
**Contexto:**  
Validacao dos dois itens pendentes da evolucao da Fase 2 relacionados ao Jenkins Kubernetes.

**Itens validados:**
1. Plugin `kubernetes` instalado e saudavel no Jenkins.
2. Cloud Kubernetes configurada em `Manage Jenkins > Clouds` apontando para o cluster local.

**Evidencias coletadas (portal):**
- Tela `Manage Jenkins > Clouds` exibindo cloud `kubernetes`.
- Cloud `kubernetes` com `Pod templates` presente (`default`).
- Configuracao da cloud exibindo:
  - `Jenkins URL`: `http://jenkins.cicd.svc.cluster.local:8080`
  - `Jenkins tunnel`: `jenkins-agent.cicd.svc.cluster.local:50000`

**Evidencias tecnicas adicionais (cluster/controller):**
- Arquivos de plugin presentes no controller:
  - `/var/jenkins_home/plugins/kubernetes.jpi`
  - `/var/jenkins_home/plugins/kubernetes-client-api.jpi`
  - `/var/jenkins_home/plugins/kubernetes-credentials.jpi`
- Cloud registrada no `config.xml` do Jenkins como:
  - `org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud`
  - `serverUrl: https://kubernetes.default`
  - `namespace: cicd`

**Resultado:**  
Os dois checks foram concluídos e marcados como `[x]` no `docs/roadmap.md`.

### [2026-03-21] Validacao RBAC do ServiceAccount Jenkins no namespace `cicd`
**Contexto:**  
Execucao de validacao objetiva do ServiceAccount `jenkins` para o item pendente da Evolucao Fase 2 relacionado a RBAC de pods.

**Comandos executados:**
- `kubectl config current-context`
- `kubectl -n cicd get sa jenkins -o wide`
- `kubectl -n cicd auth can-i create pods --as=system:serviceaccount:cicd:jenkins`
- `kubectl -n cicd auth can-i list pods --as=system:serviceaccount:cicd:jenkins`
- `kubectl -n cicd auth can-i delete pods --as=system:serviceaccount:cicd:jenkins`
- `kubectl -n cicd auth can-i get pods --as=system:serviceaccount:cicd:jenkins`
- `kubectl -n cicd auth can-i watch pods --as=system:serviceaccount:cicd:jenkins`

**Resultado observado:**
- Contexto ativo: `kind-kindops-lab`.
- ServiceAccount `jenkins` presente no namespace `cicd`.
- Permissoes validadas com retorno `yes` para:
  - `create pods`
  - `list pods`
  - `delete pods`
  - `get pods`
  - `watch pods`

**Conclusao:**  
Item de RBAC do ServiceAccount Jenkins validado e marcado como concluido (`[x]`) no `docs/roadmap.md`.

### [2026-03-21] Correcao de pre-check para reexecucao do job em pod efemero
**Contexto:**  
Antes da reexecucao do job `app-python`, foram executadas as 3 correcoes solicitadas para garantir uso do `Jenkinsfile` atualizado e disponibilidade da imagem do agent no cluster.

**Acoes executadas:**
1. Sincronizacao SCM:
   - `git push origin main` -> `Everything up-to-date`.
2. Publicacao da imagem de agent:
   - Build da imagem de CI.
   - Push validado em `localhost:5000/jenkins-agent-ci:latest`.
3. Correcao de execucao no cluster (agent image):
   - Testes de pull por `host.docker.internal:5000` e `localhost:5000` apresentaram `ImagePullBackOff` por tentativa HTTPS no runtime do node.
   - Mitigacao aplicada sem recriar cluster:
     - `kind load docker-image jenkins-agent-ci:local --name kindops-lab`.
     - Ajuste dos Jenkinsfiles para `image: jenkins-agent-ci:local`.

**Evidencias objetivas:**
- Registry local contendo tag:
  - `{"name":"jenkins-agent-ci","tags":["latest"]}`
- Erro observado no pull remoto (antes da mitigacao):
  - `http: server gave HTTP response to HTTPS client`
- Teste de pod apos mitigacao:
  - `kubectl -n cicd run image-check-local --image=jenkins-agent-ci:local ...`
  - Resultado: pod `Completed` com log `ok`.

**Arquivos alterados na mitigacao:**
- `apps/app-python/Jenkinsfile`
- `apps/app-java/Jenkinsfile`
- `docs/roadmap.md`

**Proximo passo recomendado:**  
Executar novamente o job `app-python`/`app-java` e capturar evidencias de pod `jenkins-agent-*` no namespace `cicd` para concluir os dois itens pendentes do checklist da Evolucao Fase 2.

### [2026-03-21] Registry local - inventario de imagens, tamanho e alias operacional
**Contexto:**  
Necessidade de padronizar consulta do conteudo do registry local (`localhost:5000`) e dos tamanhos de imagem para acompanhamento operacional da Fase 2.

**Comandos validados:**
- Catalogo de repositorios:
  - `curl -s http://localhost:5000/v2/_catalog`
- Tags por repositorio:
  - `curl -s http://localhost:5000/v2/<repo>/tags/list`
- Calculo de tamanho por `repo:tag` via manifest/layers:
  - script com suporte a manifest list/index (quando `.layers` nao existe no primeiro retorno).

**Inventario observado no momento da validacao:**
- `app-java:b6150be`
- `app-python:b6150be`
- `jenkins-agent-ci:latest`

**Tamanhos observados no momento da validacao:**
- `app-java:b6150be -> 109.07 MB (114368113 bytes)`
- `app-python:b6150be -> 52.45 MB (54998587 bytes)`
- `jenkins-agent-ci:latest -> 343.96 MB (360670425 bytes)`

**Alias/funcao recomendada (WSL/bash):**
- Nome sugerido: `regsizes`
- Objetivo: listar automaticamente `repo:tag` e tamanho total por imagem no registry local.
- Aplicacao:
  1. adicionar funcao no `~/.bashrc`
  2. executar `source ~/.bashrc`
  3. usar `regsizes` para consulta recorrente

**Resultado:**  
Consulta do registry local ficou padronizada para operacao e troubleshooting de CI/pipeline durante a Evolucao Fase 2.

### [2026-03-22] Jenkins - troubleshooting de CrashLoopBackOff e retorno ao estado estavel
**Contexto:**  
Durante a evolucao da Fase 2, o controller Jenkins apresentou instabilidade com pod `jenkins-0` alternando entre `Init:1/2`, `pending-upgrade` de release Helm e falhas de inicializacao.

**Causa raiz observada no ciclo de falha:**
- conflito de dependencia de plugins no `init` do Jenkins:
  - `git:5.10.0` requer `eddsa-api:0.3.0.1-19.vc432d923e5ee`;
  - a versao pinada no ciclo de tentativa estava inferior, causando `Plugin prerequisite not met`.
- release Helm ficou com revisoes `failed` e uma tentativa em `pending-upgrade`.

**Comandos executados para validacao/recuperacao:**
- `helm history jenkins -n cicd`
- `helm status jenkins -n cicd`
- `kubectl -n cicd get pods -o wide`
- `kubectl -n cicd describe pod jenkins-0`
- `kubectl -n cicd logs jenkins-0 -c init --previous --tail=220`
- `helm rollback jenkins 11 -n cicd --wait --timeout 10m`
- `kubectl -n cicd rollout status statefulset/jenkins --timeout=120s`

**Resultado observado apos rollback:**
- rollback para revisao estavel concluido com sucesso.
- `jenkins-0` estabilizado em `2/2 Running`, com `RESTARTS=0`.
- rollout do `statefulset/jenkins` concluido.

**Warnings ainda presentes (nao bloqueantes para subida):**
- health check de plugins com falha para `trilead-api` e `jsch`.
- warning de URL invalida no startup:
  - `Invalid URL received: localhost:8080/, considered as null`.

**Decisao tomada:**
- manter ambiente no estado estavel (rev 11) para nao bloquear execucao dos itens restantes da Fase 2.
- planejar ajuste de versoes/plugins em janela controlada antes de novo `helm upgrade`.

### [2026-03-22] Jenkins pipeline - falha de pod efemero por cgroup cpu quota
**Contexto:**  
Na tentativa de fechar a validacao de build em pod efemero, o job `app-python` criou o pod dinamico no namespace `cicd`, mas o container principal `ci` nao inicializou.

**Evidencia do erro:**
- `Container [ci] terminated [StartError]`
- `failed to write ".../cpu.cfs_quota_us: invalid argument"`

**Diagnostico:**
- O problema nao estava na cloud Kubernetes do Jenkins (pod chegou a ser criado).
- A falha ocorreu no runtime do node ao aplicar quota de CPU do container.
- O `podTemplate` estava com `limits.cpu: "2000m"` em ambos Jenkinsfiles.

**Correcao aplicada:**
- Removido `limits.cpu` dos pod templates:
  - `apps/app-python/Jenkinsfile`
  - `apps/app-java/Jenkinsfile`
- Mantidos:
  - `requests.cpu: "500m"`
  - limites de memoria (`2Gi`)

**Resultado esperado apos ajuste:**
- container `ci` inicia sem `StartError`;
- pipeline entra nos stages normalmente dentro do pod efemero.

**Proximo passo:**
- reexecutar o job e coletar evidencias para fechar item pendente no roadmap.

### [2026-03-22] Jenkins pipeline - validacao de pod efemero e ajuste de workspace da app
**Contexto:**  
Reexecucao do job `app-python` apos ajuste de `limits.cpu`.

**Resultado observado:**
- Pod efemero criado e conectado com sucesso:
  - `Created Pod: kubernetes cicd/app-python-7-*`
  - `Running on app-python-7-* in /home/jenkins/agent/workspace/app-python`
- Isso comprovou que os stages nao estao rodando no controller `jenkins-0`.

**Falha encontrada na sequencia:**
- stage `lint`:
  - `ERROR: Could not open requirements file: [Errno 2] No such file or directory: 'requirements-dev.txt'`

**Diagnostico:**
- checkout ocorre na raiz do repo;
- arquivos da app Python ficam em `apps/app-python`;
- comandos do pipeline estavam executando sem `dir(...)`.

**Correcao aplicada:**
- Inclusao de `APP_DIR` e encapsulamento de stages com `dir("${APP_DIR}")` em:
  - `apps/app-python/Jenkinsfile`
  - `apps/app-java/Jenkinsfile`

**Proximo passo:**
- reexecutar build para validar execucao completa dos stages no pod efemero e fechar item pendente da Evolucao Fase 2.

### [2026-03-22] Jenkins pipeline - erro de import Python no stage unit
**Contexto:**  
Nova execucao do job `app-python` com commit `0f5f0c0` (correcao de workspace) aplicada.

**Resultado observado:**
- Pod efemero criado e conectado normalmente.
- Stage `lint` executado com sucesso (`ruff check ...` passou).
- Stage `unit` falhou com:
  - `ModuleNotFoundError: No module named 'app'`.

**Diagnostico:**
- Mesmo no diretorio correto da app, o `pytest` no agent nao resolveu o pacote local sem `PYTHONPATH`.

**Correcao aplicada:**
- Em `apps/app-python/Jenkinsfile`:
  - `unit`: `PYTHONPATH=. pytest -q tests/test_unit_health.py`
  - `integration`: `PYTHONPATH=. pytest -q tests/test_integration_http.py`

**Proximo passo:**
- reexecutar o job para validar `unit`/`integration` e continuidade das stages ate `build/push`.
