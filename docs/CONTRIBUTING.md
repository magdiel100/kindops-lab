# Contributing Guide

## Convencoes de branch
- `main`: branch protegida e estavel.
- `feature/<tema-curto>`: novas funcionalidades.
- `fix/<tema-curto>`: correcao de bug.
- `chore/<tema-curto>`: manutencao/infra/ajustes.
- `docs/<tema-curto>`: alteracoes de documentacao.

Exemplos:
- `feature/argocd-rollouts`
- `fix/otel-metrics-labels`

## Fluxo de contribuicao
1. Crie branch a partir de `main`.
2. Faça commits pequenos e com contexto claro.
3. Abra PR usando template.
4. Garanta checklist e CI verdes antes de merge.
5. Merge via squash para manter historico limpo.

## Padrao de commit (recomendado)
- `feat: ...`
- `fix: ...`
- `docs: ...`
- `chore: ...`
- `refactor: ...`
- `test: ...`

## Checklist minimo para PR
- Escopo claro e limitado.
- Testes executados (ou justificativa).
- Impactos/riscos descritos.
- Documentacao atualizada quando aplicavel.
- Sem segredos hardcoded.
