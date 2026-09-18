---
name: post-task-simplicity-review
description: >-
  Após concluir implementação ou correção, revisa se a solução ficou na forma
  mais simples possível, sem lógica desnecessária ou difícil de entender.
  Use sempre que terminar uma tarefa com mudança de código, config ou scripts
  e antes do resumo final ao usuário. Não use para respostas só explicativas
  sem alterações.
---

# Revisão de simplicidade após a tarefa

## Quando aplicar

Aplique **depois** de concluir o trabalho pedido e **antes** de encerrar a resposta, quando houver **alterações** (código, config, migrations, scripts).

**Pule** se não houve mudanças no repositório ou ambiente.

## O que fazer

1. Releia o diff / arquivos tocados (não confie só na memória).
2. Pergunte: *“Um dev novo neste repo entenderia isso em poucos minutos?”*
3. Use o checklist abaixo.
4. Se algo falhar no checklist, **simplifique agora** (diff mínimo adicional) ou **reverta** complexidade introduzida sem ganho claro.
5. No resumo final ao usuário, inclua a seção **Revisão de simplicidade** (mesmo que seja “nada a ajustar”).

## Checklist

Marque mentalmente cada item; qualquer “não” exige ação:

- [ ] **Escopo mínimo** — nada além do pedido confirmado
- [ ] **Sem over-engineering** — sem camadas, abstrações ou helpers de uma linha só para “elegância”
- [ ] **Sem lógica alienígena** — sem truques obscuros, flags encadeadas ou fluxo que exija comentário longo para entender
- [ ] **Consistente com o repo** — nomes, padrões e bibliotecas já usados no arquivo/pasta
- [ ] **Caminho óbvio** — a solução escolhida é a mais direta que ainda está correta
- [ ] **Comentários** — só onde a regra de negócio ou detalhe técnico não é óbvio pelo código

## Sinais de alerta (simplificar)

- Função genérica usada uma vez
- Indireção extra (wrapper, factory, strategy) sem requisito real
- Duplicação evitada com metaprogramação ou reflexão desnecessária
- Condições aninhadas que virariam early return ou extração local óbvia
- Nomes vagos (`data`, `handler`, `process`, `utils`) onde o domínio tem termo claro

## Formato no resumo final (obrigatório)

```markdown
## Revisão de simplicidade

- **Veredito:** OK | Ajustei antes de entregar
- **O que checkei:** [1–3 bullets curtos]
- **Ajustes feitos:** [só se houver — o que simplificou e por quê]
```

Se **Ajustei antes de entregar**, mencione brevemente o que mudou; não esconda refactor de simplificação no meio do texto.

## Regras

- Simplicidade **não** significa ignorar edge cases necessários — significa não complicar além do necessário.
- Não expanda escopo na fase de simplificação (sem “já que estou aqui…”).
- Alinhe com `/minimal-change` e as rules do projeto (Clean Architecture, diff mínimo).
