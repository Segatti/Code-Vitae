---
name: task-intent-confirmation
description: >-
  Reformula pedidos do usuário em objetivo, escopo e passos claros e aguarda
  confirmação antes de implementar. Use no início de tarefas de implementação,
  refatoração, debug com mudança de código, configuração ou automação — antes de
  editar arquivos, commits ou comandos destrutivos. Não use para perguntas
  puramente informativas sem ação.
---

# Confirmação de intenção antes da tarefa

## Quando aplicar

Aplique **antes** de executar a tarefa quando o pedido implicar **ação** (código, config, git, scripts, deploy, dados).

**Pule** esta skill quando for só:
- explicação ou leitura de código, sem alteração pedida;
- continuação óbvia de um plano já confirmado na mesma conversa;
- correção mínima explícita (“sim, pode fazer exatamente isso” logo após um resumo seu).

## O que fazer

1. Leia o pedido completo e o contexto recente do chat.
2. Converta em linguagem **simples, clara e objetiva** (sem jargão desnecessário).
3. **Pare** — não implemente, não edite arquivos, não rode comandos que alterem o projeto até o dev confirmar.
4. Apresente o resumo no formato abaixo e peça confirmação.

## Formato de saída (obrigatório)

Use exatamente estas seções:

```markdown
## Entendi assim

**Objetivo:** [uma frase — o que deve estar verdadeiro no final]

**Escopo (fazer):**
- [item concreto]
- …

**Fora do escopo (não fazer):**
- [item ou “nada explícito — assumo só o escopo acima”]

**Passos que pretendo executar:**
1. …
2. …

**Premissas:** [o que você está assumindo se o pedido não deixou claro]

**Riscos / dúvidas:** [opcional — só se houver ambiguidade real]

---
Confirma? Responda **sim** para eu executar, ou corrija o que estiver errado.
```

## Regras

- Prefira **menos passos** e **menor escopo** quando o pedido permitir interpretações; declare a interpretação escolhida em **Premissas**.
- Se houver duas leituras plausíveis, liste-as em **Riscos / dúvidas** e peça qual seguir — ainda sem implementar.
- Após **sim** (ou correção incorporada + novo **sim**), execute só o escopo confirmado.
- Se o usuário disser **não** ou mudar o escopo, regenere o bloco **Entendi assim** e aguarde de novo.

## Exemplo curto

**Pedido:** “Arruma o login que quebrou no mobile.”

**Resposta (parar aqui):**

## Entendi assim

**Objetivo:** Login voltar a funcionar no app mobile.

**Escopo (fazer):**
- Reproduzir/diagnosticar a falha no fluxo de login mobile
- Corrigir a causa raiz com diff mínimo

**Fora do escopo (não fazer):**
- Redesign de UI ou refactor amplo de auth

**Passos que pretendo executar:**
1. Localizar fluxo de login mobile no repo
2. Identificar regressão (commit, API, token, etc.)
3. Aplicar correção mínima e validar

**Premissas:** “Mobile” = app Flutter Aluga Comigo (`mobile/aluga_comigo`), ambiente dev local.

**Riscos / dúvidas:** Não sei se o bug é só iOS, só Android ou ambos.

---
Confirma? Responda **sim** para eu executar, ou corrija o que estiver errado.
