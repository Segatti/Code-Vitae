# Compras in-app (IAP) — Google Play e App Store

Guia operacional para o item **3** do checklist de publicação ([`docs/reports/2026-10-18-publicacao-lojas.md`](reports/2026-10-18-publicacao-lojas.md)).

## Product IDs (obrigatório: idênticos ao app)

Os IDs vêm de [`lib/app/modules/store/interactor/models/store_catalog.dart`](../lib/app/modules/store/interactor/models/store_catalog.dart):

| Product ID | Tipo sugerido na loja | Descrição |
|------------|----------------------|-----------|
| `first_purchase_offer` | Consumível | Pacote boas-vindas (1× por conta) |
| `power_up_24h` | Consumível | PowerUp 24h |
| `power_up_7d` | Consumível | PowerUp 7 dias |
| `power_up_30d` | Consumível | PowerUp 30 dias |
| `super_star_1` | Consumível | 2 Super Star |
| `super_star_2` | Consumível | 5 Super Star |
| `super_star_3` | Consumível | 10 Super Star |
| `super_chat_1` | Consumível | 2 Super Chat |
| `super_chat_2` | Consumível | 5 Super Chat |
| `super_chat_3` | Consumível | 10 Super Chat |

**Package / bundle:** `com.fluttercraft.alugaComigo`

## Google Play Console

1. Monetização → Produtos → **Produtos in-app** → criar cada ID acima como **consumível**.
2. Definir preço base (BRL); o app exibe o preço retornado pela loja quando disponível (`ProductDetails.price`).
3. Conta de **teste** (License testing) para sandbox.
4. Assinatura do app em **Internal testing** ou **Closed testing** antes de produção.

## App Store Connect

1. App → **Compras dentro do app** → criar produtos **consumíveis** com os mesmos IDs.
2. Preencher localização PT-BR, preço e screenshot de review se solicitado.
3. Usuários **Sandbox** em Users and Access → Sandbox Testers.
4. Contratos, banking e fiscal ativos (Paid Apps Agreement).

## Fluxo técnico no app

1. `in_app_purchase` consulta preços (`StoreController.initialize`).
2. Compra → `PurchaseRepository.handlePurchaseUpdate` → `POST /v1/purchases/fulfill` (API Dart) → inventário Supabase.
3. **Restaurar compras:** botão na [`StorePage`](../lib/app/modules/store/ui/pages/store_page.dart) chama `InAppPurchase.restorePurchases()`; transações `restored` passam pelo mesmo fulfill (créditos consumíveis podem não reaparecer — texto legal na UI).

## Checklist de teste (sandbox)

- [ ] Cada product ID retorna preço na loja (sem “Loja indisponível”).
- [ ] Compra sandbox → créditos/PowerUp refletidos na UI.
- [ ] Segunda compra do `first_purchase_offer` rejeitada (backend).
- [ ] Links **Termos** e **Privacidade** na loja abrem.
- [ ] Restaurar compras não quebra o fluxo (mesmo sem novos créditos).

## Legal e lojas

- Texto de reembolso/CDC na rodapé da loja in-app.
- Play **Data safety** e Apple **Privacy Nutrition Labels**: declarar dados de compra/processamento pela loja.
- Política de privacidade deve mencionar Google Play / App Store como processadores de pagamento.

## Referências

- Backend fulfill: [`backend/README.md`](../backend/README.md)
- Migration oferta 1ª compra: [`supabase/migrations/028_first_purchase_offer.sql`](../supabase/migrations/028_first_purchase_offer.sql)
