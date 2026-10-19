# Push de chat com Firebase Cloud Messaging (FCM)

Este guia configura **notificação nativa** (app fechado ou em segundo plano) para mensagens de chat.

Analytics e Crashlytics usam o mesmo projeto e `--dart-define` Firebase — ver [`docs/analytics.md`](analytics.md).

## 1. Firebase Console

1. Crie um projeto em [Firebase Console](https://console.firebase.google.com/) (ou use o existente).
2. Adicione app **Android** (`com.fluttercraft.alugaComigo`) e baixe `google-services.json` →  
   `android/app/google-services.json`
3. Adicione app **iOS** (`com.fluttercraft.alugaComigo`) e baixe `GoogleService-Info.plist` →  
   `ios/Runner/GoogleService-Info.plist`
4. Em **Project settings → Cloud Messaging**, anote o **Sender ID** (mesmo valor de `messagingSenderId`).
5. Em **Project settings → Service accounts**, gere uma **chave JSON** (conta de serviço Firebase Admin).

## 2. Dart defines (Flutter)

Inclua no `dart_defines.json` / script de run (ex.: `scripts/genDeviceDefines.sh`):

```json
{
  "FIREBASE_PROJECT_ID": "seu-projeto-id",
  "FIREBASE_API_KEY": "...",
  "FIREBASE_APP_ID": "1:...:android:...",
  "FIREBASE_MESSAGING_SENDER_ID": "...",
  "FIREBASE_IOS_BUNDLE_ID": "com.fluttercraft.alugaComigo"
}
```

Valores equivalentes estão no `google-services.json` / `GoogleService-Info.plist`.  
Alternativa: `dart pub global activate flutterfire_cli` e `flutterfire configure` (gera defines ou `firebase_options.dart`).

Sem esses defines, o app **não** inicializa FCM (continua com push local + Realtime).

## 3. Supabase — migration e secrets

1. Aplique a migration `021_device_push_tokens_fcm.sql` (`supabase db push` ou pipeline habitual).
2. Deploy da Edge Function:

```bash
cd mobile/aluga_comigo
supabase functions deploy send-chat-push --no-verify-jwt
```

3. Secrets da function (Dashboard → Edge Functions → send-chat-push → Secrets):

| Secret | Conteúdo |
|--------|----------|
| `FIREBASE_SERVICE_ACCOUNT` | JSON completo da conta de serviço (uma linha) |
| `PUSH_WEBHOOK_SECRET` | String aleatória longa (ex.: `openssl rand -hex 32`) |
| `SUPABASE_URL` | URL do projeto |
| `SUPABASE_SERVICE_ROLE_KEY` | Service role (somente server-side) |

4. **Database settings** (SQL no projeto hosted — substitua valores):

```sql
ALTER DATABASE postgres SET app.settings.supabase_url = 'https://SEU_REF.supabase.co';
ALTER DATABASE postgres SET app.settings.push_webhook_secret = 'MESMO_VALOR_DE_PUSH_WEBHOOK_SECRET';
```

O trigger em `user_notifications` (tipo `chatMessage`) chama `send-chat-push` via `pg_net`.

## 4. iOS (APNs)

1. No Firebase, faça upload da **APNs Auth Key** (.p8) ou certificado.
2. No Xcode: **Signing & Capabilities** → **Push Notifications** + **Background Modes** → Remote notifications.

## 5. Teste

1. Login no app (token FCM é salvo em `device_push_tokens`).
2. Feche o app ou envie para segundo plano.
3. Envie mensagem de outro usuário → deve aparecer notificação do sistema; ao tocar, abre o chat.

## Fluxo

```text
INSERT mensagem → trigger user_notifications (chatMessage)
  → pg_net → Edge Function send-chat-push
  → FCM HTTP v1 → dispositivo
```

Toque na notificação: `FcmPushService` → `ChatNavigation.openById(chatId)`.
