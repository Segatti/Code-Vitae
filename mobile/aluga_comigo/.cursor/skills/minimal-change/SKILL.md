---
name: minimal-change
description: >-
  Simplifica alterações ao mínimo necessário para atingir o objetivo. Refatora
  para helper somente quando lógica repetida em 2+ pontos. Use em toda
  implementação, bugfix, refactor ou feature no projeto Flutter.
---

# Minimal Change

## Regra principal

sempre simplifique as alterações para o minimo de alteração para atingir o objetivo pedido e somente deve ser refatorado quando uma logica só usada em varios pontos do sistema e deve ser um helper

## Antes de editar

1. Identificar a **camada Clean Architecture** correta (domain / data / presenter)
2. Identificar o **menor conjunto de arquivos** que resolve o pedido
3. Ler código existente e seguir convenções do módulo (naming, pastas, DI)
4. Confirmar se a mudança exige helper ou basta editar inline

## Durante a implementação

- Não renomear/mover arquivos fora do escopo
- Não reformatar arquivos inteiros fora do escopo
- Não trocar stack (Riverpod, Bloc, go_router) unless pedido explicitamente
- Não extrair abstrações "por precaução" com uso único
- Não refatorar código adjacente que funciona

## Quando criar helper

Refatorar para helper **somente** se:
- A mesma lógica aparece em **2 ou mais pontos** do sistema (confirmar com grep)
- O helper tem responsabilidade clara e nome descritivo

**Onde colocar helpers:**
- Compartilhado: `lib/app/shared/domain/helpers/`
- Local ao módulo: `domain/helpers/` dentro do módulo

## Ao finalizar

Listar arquivos tocados e justificar cada um:

```markdown
## Arquivos alterados
- `path/file.dart` — motivo em 1 linha
```

## Exemplos

**Pedido:** corrigir mensagem de erro no login
- ✅ Editar `auth_controller.dart` (1 arquivo)
- ❌ Refatorar todo módulo auth + extrair ErrorHandler global

**Pedido:** validar CPF em signup e profile
- ✅ Criar `validator_helper.dart` (2+ usos confirmados)
- ❌ Duplicar regex inline em cada controller
