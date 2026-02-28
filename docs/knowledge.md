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
