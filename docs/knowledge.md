# Knowledge Base - kindops-lab

## Objetivo
Centralizar aprendizado tecnico do projeto para estudo continuo e retomada rapida.

## Como usar este arquivo
- Registre cada sessao de estudo com data.
- Explique com palavras proprias: o que e, para que serve e como usar.
- Documente decisoes e trade-offs.
- Relacione erros, causa raiz e correcao.
- Deixe links para arquivos do projeto e documentacao oficial.

## Estrutura recomendada por entrada
### [AAAA-MM-DD] Tema
- Contexto:
- Conceitos-chave:
- O que e:
- Para que serve:
- Como usar no kindops-lab:
- Decisao tomada:
- Trade-offs:
- Comandos testados:
- Resultado observado:
- Erros encontrados:
- Correcao aplicada:
- Evidencias (arquivos/prints):
- Proximo passo:

### [2026-02-26] Fase 0 - Fundacao e padroes
**Contexto:**  
Inicio oficial do projeto com foco em base organizacional, padroes de contribuicao e estrutura minima para escalar sem retrabalho.

**Conceitos-chave:**
- **Scaffold de repositorio**
  - Esqueleto inicial do projeto com pastas, arquivos base e convencoes minimas para comecar com organizacao.
  - Exemplos no projeto: `apps/`, `infra/`, `docs/`, `README.md`, `Makefile`.
- **Templates de PR/Issue**
  - Formularios padrao para abrir Pull Requests e Issues no GitHub.
  - Forcam informacao minima util (objetivo, impacto, testes, evidencias), melhorando revisao e rastreabilidade.
- **Bootstrap automatizado**
  - Comando/script para preparar a base do projeto automaticamente, evitando criacao manual repetitiva.
  - Exemplo no projeto: `make bootstrap` para criar diretorios e arquivos iniciais de forma padronizada.
- **Padronizacao de fluxo e Definition of Done da fase**

**O que e:**  
Fase de preparacao estrutural do projeto antes de implementar infraestrutura e workloads.

**Para que serve:**  
Reduzir improviso, garantir consistencia de contribuicoes e facilitar retomada do projeto em qualquer momento.

**Como usar no kindops-lab:**  
Executar bootstrap para garantir estrutura minima, seguir `CONTRIBUTING.md` em toda mudanca e abrir PR/Issues com template.

**Decisao tomada:**  
Criar estrutura base completa + arquivos de governanca (`README`, `Makefile`, templates e guia de contribuicao) antes da Fase 1.

**Trade-offs:**  
Investimento inicial em documentacao e organizacao atrasou a parte tecnica de deploy, mas reduz risco de desorganizacao nas fases seguintes.

**Comandos testados:**
- `find /mnt/c/Users/magdi/Documents/projetos/kindops-lab -maxdepth 3 -type d | sort`
- `find /mnt/c/Users/magdi/Documents/projetos/kindops-lab -maxdepth 3 -type f | sort`
- `cd /mnt/c/Users/magdi/Documents/projetos/kindops-lab && make bootstrap`
- `cd /mnt/c/Users/magdi/Documents/projetos/kindops-lab && mkdir -p apps infra/terraform infra/ansible charts gitops observability .github/ISSUE_TEMPLATE docs`

**Resultado observado:**
- Estrutura de diretorios da Fase 0 criada com sucesso.
- `Makefile` criado com alvo `bootstrap`.
- Templates de PR/Issue e guia de contribuicao adicionados.
- README com pre-requisitos, estrutura e inicio rapido criado.

**Erros encontrados:**  
`make: command not found` no ambiente atual.

**Correcao aplicada:**  
Estrutura criada manualmente com `mkdir -p` para nao bloquear progresso; `Makefile` mantido para uso quando `make` estiver disponivel.

**Evidencias (arquivos/prints):**
- `README.md`
- `Makefile`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/bug_report.md`
- `.github/ISSUE_TEMPLATE/feature_request.md`
- `docs/CONTRIBUTING.md`
- Diretorios: `apps/`, `infra/terraform/`, `infra/ansible/`, `charts/`, `gitops/`, `observability/`, `docs/`

**Proximo passo:**  
Iniciar Fase 1 com bootstrap tecnico do ambiente local (kind + helm + base de observabilidade) e registrar cada sessao neste documento.
