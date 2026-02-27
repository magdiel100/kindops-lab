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
