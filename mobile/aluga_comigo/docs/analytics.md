# Firebase Analytics e Crashlytics — Aluga Comigo

Documentação dos eventos instrumentados no app mobile e como habilitar em produção.

## Habilitação

1. Mesmo projeto Firebase usado para FCM ([`docs/fcm-setup.md`](fcm-setup.md)).
2. `--dart-define-from-file` com `FIREBASE_*` (ver [`lib/firebase_config.dart`](../lib/firebase_config.dart)).
3. **Android:** `google-services.json` em `android/app/` (gitignored); plugin Crashlytics aplicado quando o arquivo existe.
4. **iOS:** `GoogleService-Info.plist`; habilitar Crashlytics no Xcode se necessário.
5. Firebase Console → **Analytics** e **Crashlytics** ativos no projeto.

Sem defines Firebase, o app usa `NoOpAnalyticsService` e não envia eventos; Crashlytics não inicializa.

## Implementação no código

| Componente | Caminho |
|------------|---------|
| Nomes de eventos / parâmetros | [`lib/app/shared/domain/analytics/analytics_events.dart`](../lib/app/shared/domain/analytics/analytics_events.dart) |
| Serviço de analytics | [`lib/app/shared/data/services/analytics_service.dart`](../lib/app/shared/data/services/analytics_service.dart) |
| Crashlytics + handlers globais | [`lib/app/shared/data/services/firebase_observability_service.dart`](../lib/app/shared/data/services/firebase_observability_service.dart) |
| Bootstrap | [`lib/app/app_bootstrap.dart`](../lib/app/app_bootstrap.dart) |

Crashlytics coleta erros fatais Flutter e não tratados; em **debug** a coleta fica desligada.

## User properties

| Propriedade | Quando | Valores |
|-------------|--------|---------|
| `user_type` | Após login/cadastro | `person`, `immobile` |
| User ID | Após login/cadastro | UUID da conta (`SessionService.customer.id`) |

## Eventos customizados

Convenções alinhadas a GA4 (nomes em snake_case, parâmetros limitados a tipos suportados pelo SDK).

### Aquisição e conta

| Evento | Onde | Parâmetros | Uso de produto |
|--------|------|------------|----------------|
| `login` | `AuthController` | `method`: `email` | Funil de retenção, DAU |
| `sign_up` | `AuthController` | `method`: `email` | Conversão cadastro |

### Discovery / match (core do app)

| Evento | Onde | Parâmetros | Uso de produto |
|--------|------|------------|----------------|
| `swipe_action` | `CustomersController`, `HousesController` | `match_type`, `target_type` | Engajamento feed, balanceamento like/dislike |
| `match` | Idem (match mútuo) | `is_mutual`, `target_type` | North-star proxy, eficácia do produto |

### Chat

| Evento | Onde | Parâmetros | Uso de produto |
|--------|------|------------|----------------|
| `chat_open` | `ChatController.initialize` | `chat_id` | Profundidade de uso pós-match |
| `chat_message_sent` | Envio texto / Super Chat | `chat_id`, `message_type`: `text` \| `super_chat` | Conversão para conversa real, monetização Super Chat |

### Loja (monetização)

| Evento | Onde | Parâmetros | Uso de produto |
|--------|------|------------|----------------|
| `store_view` | `StorePage` init | — | Intenção de compra |
| `begin_checkout` | Antes de abrir fluxo IAP | `item_id`, `item_category` | Funil loja (padrão e-commerce) |
| `purchase` | Fulfill OK | `item_id`, `transaction_id` | Receita in-app (complementar à Play/App Store) |
| `purchase_failed` | Erro no fulfill/IAP | `item_id`, `error_message` | Diagnóstico |
| `restore_purchases` | Botão restaurar | — | Conformidade Apple / suporte |

### UGC / segurança

| Evento | Onde | Parâmetros | Uso de produto |
|--------|------|------------|----------------|
| `report_started` | Abrir denúncia | `report_context` | Volume de moderação |
| `report_submitted` | Ticket categoria denúncia | `report_context` | SLA moderação |
| `user_blocked` | Bloqueio confirmado | `report_context` | Saúde da comunidade |

Valores de `report_context`: `profile`, `chat`, `listing`.

## Eventos automáticos Firebase

Com Analytics ativo, o SDK também registra (entre outros):

- `first_open`, `session_start`, `user_engagement`
- Informações de dispositivo e app (versão, OS)

Não duplicamos `screen_view` em todas as rotas nesta fase; telas críticas podem ser adicionadas via `IAnalyticsService.logScreenView` quando necessário.

## Privacidade (LGPD / lojas)

- Declarar Firebase Analytics e Crashlytics na Política de Privacidade e nos formulários Play/App Store.
- User ID é o identificador interno da conta; não enviar e-mail ou CPF em parâmetros de evento.
- Respeitar opt-out de analytics quando a plataforma/usuário exigir (evolução futura: flag em config).

## Dashboards sugeridos (Firebase / BigQuery)

1. **Funil:** `sign_up` → `swipe_action` → `match` → `chat_open` → `chat_message_sent`
2. **Monetização:** `store_view` → `begin_checkout` → `purchase` (taxa por `item_id`)
3. **Confiança:** `report_submitted` + `user_blocked` por semana
4. **Estabilidade:** Crashlytics — crashes por versão (`1.0.1+2` em `pubspec.yaml`)

## Referências

- Checklist publicação: [`docs/reports/2026-10-18-publicacao-lojas.md`](reports/2026-10-18-publicacao-lojas.md)
- IAP: [`docs/iap-setup.md`](iap-setup.md)
