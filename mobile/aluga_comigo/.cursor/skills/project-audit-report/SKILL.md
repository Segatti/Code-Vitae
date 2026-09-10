---
name: project-audit-report
description: >-
  Gera relatório markdown de auditoria do projeto: bugs, melhorias, insights
  de mercado e oportunidades. Salva em docs/reports/. Use para audit, roadmap,
  quality report, ou contexto para IA.
disable-model-invocation: true
---

# Project Audit Report — Flutter Mobile

Gera arquivo `.md` estruturado para **humanos e IAs** reutilizarem depois.

## Quando usar

- Antes de release ou sprint planning
- Após MVP para identificar gaps
- Quando precisar de contexto persistente para agentes (`@docs/reports/...`)

## Fluxo

1. **Coletar contexto**
   - Ler `pubspec.yaml`, `AGENTS.md`, estrutura `lib/app/modules/`
   - `dart analyze` (se disponível)
   - `git diff main...HEAD` se audit pós-mudanças

2. **Delegar análise** → subagent `project-insights-reviewer` (readonly)
   - Prompt inclua: escopo (paths), tipo de app, público-alvo se conhecido

3. **Consolidar** no template abaixo

4. **Salvar arquivo**
   - Path: `docs/reports/YYYY-MM-DD-[escopo]-audit.md`
   - Exemplo: `docs/reports/2026-09-09-full-project-audit.md`
   - Se escopo parcial: `docs/reports/2026-09-09-auth-module-audit.md`

5. **Informar usuário** com path do arquivo gerado

## Foco mobile

- Supabase (Auth, PostgreSQL, Storage) — RLS e políticas
- Permissões (câmera, localização)
- Performance de listas e imagens
- Offline / conectividade
- UX mobile (teclado, SafeArea, gestos)

## Template do relatório (copiar estrutura exata)

```markdown
---
report_type: project_audit
project: aluga_comigo
scope: [full | module/name | paths]
generated_at: YYYY-MM-DD
auditor: project-insights-reviewer
for_ai: true
---

# Audit Report — [Título]

> Contexto para IA: relatório objetivo. Prioridades P0–P3. IDs estáveis ([BUG-001]).

## Resumo executivo
- **Saúde geral:** [Boa | Média | Crítica]
- **P0 abertos:** N
- **Top 3 ações:** 1. ... 2. ... 3. ...

## Métricas rápidas
| Métrica | Valor |
|---------|-------|
| dart analyze | pass/fail |
| Testes | N passando |
| Módulos | listar |
| Cobertura estimada | baixa/média/alta |

## Bugs potenciais
### [BUG-001] Título
- **Prioridade:** P0|P1|P2
- **Onde:** `path:linha`
- **Problema:** ...
- **Exemplo:** ```dart\n// código ou cenário\n```
- **Sugestão:** ...
- **Esforço:** S|M|L

## Melhorias técnicas
### [IMP-001] Título
(mesmo formato, Tipo: melhoria)

## Insights de mercado
### [MKT-001] Título
- **Tendência:** ...
- **Impacto no produto:** ...
- **O que adicionar:** feature/melhoria concreta
- **Exemplo no mercado:** app referência
- **Esforço:** S|M|L

## Oportunidades de produto
### [OPP-001] Título
- **Proposta:** ...
- **Por quê agora:** ...
- **Implementação inicial:** passos enxutos
- **Esforço:** S|M|L

## Backlog sugerido (ordenado)
| ID | Item | Prioridade | Esforço | Sprint sugerido |
|----|------|------------|---------|-----------------|
| BUG-001 | ... | P0 | S | agora |

## Referências analisadas
- `lib/...`
- `test/...`

## Notas para próxima IA
Instruções curtas: o que já foi decidido, o que ignorar, próximo passo recomendado.
```

## Regras de escrita (for_ai: true)

- IDs estáveis (`BUG-001`, `IMP-002`) — IAs referenciam em PRs/commits
- Cada item: **Problema + Exemplo + Sugestão** (nunca só uma frase vaga)
- Código em blocos fenced com linguagem
- Máx 15 achados no corpo; resto vai para backlog
- Seção "Notas para próxima IA" obrigatória no final

## Paralelo opcional

Se projeto grande, disparar em paralelo (readonly):
- `project-insights-reviewer` → foco bugs + melhorias em `lib/`
- `architecture-reviewer` → violações de camada
- Lead consolida num único `.md`

## Não fazer

- Sobrescrever report existente sem confirmar com usuário
- Relatório sem exemplos concretos
- Omitir seção de mercado se app tiver usuários externos
