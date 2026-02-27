# Contributing Guide

## Convenções de branch
- `main`: branch protegida e estável.
- `feature/<tema-curto>`: novas funcionalidades.
- `fix/<tema-curto>`: correção de bug.
- `chore/<tema-curto>`: manutenção/infra/ajustes.
- `docs/<tema-curto>`: alterações de documentação.

Exemplos:
- `feature/argocd-rollouts`
- `fix/otel-metrics-labels`

## Fluxo de contribuição
1. Crie branch a partir de `main`.
2. Faça commits pequenos e com contexto claro.
3. Abra PR usando template.
4. Garanta checklist e CI verdes antes de merge.
5. Merge via squash para manter histórico limpo.

## Padrão de commit (recomendado)
- `feat: ...`
- `fix: ...`
- `docs: ...`
- `chore: ...`
- `refactor: ...`
- `test: ...`

## Checklist mínimo para PR
- Escopo claro e limitado.
- Testes executados (ou justificativa).
- Impactos/riscos descritos.
- Documentação atualizada quando aplicável.
- Sem segredos hardcoded.
