/// Nomes de eventos e parâmetros — espelham convenções GA4 / Firebase Analytics.
abstract final class AnalyticsEvents {
  static const login = 'login';
  static const signUp = 'sign_up';
  static const screenView = 'screen_view';

  static const swipeAction = 'swipe_action';
  static const match = 'match';

  static const chatOpen = 'chat_open';
  static const chatMessageSent = 'chat_message_sent';

  static const storeView = 'store_view';
  static const beginCheckout = 'begin_checkout';
  static const purchase = 'purchase';
  static const purchaseFailed = 'purchase_failed';
  static const restorePurchases = 'restore_purchases';

  static const reportStarted = 'report_started';
  static const reportSubmitted = 'report_submitted';
  static const userBlocked = 'user_blocked';
}

abstract final class AnalyticsParams {
  static const method = 'method';
  static const userType = 'user_type';
  static const screenName = 'screen_name';
  static const screenClass = 'screen_class';

  static const matchType = 'match_type';
  static const targetType = 'target_type';
  static const isMutual = 'is_mutual';

  static const chatId = 'chat_id';
  static const messageType = 'message_type';

  static const itemId = 'item_id';
  static const itemCategory = 'item_category';
  static const currency = 'currency';
  static const value = 'value';
  static const transactionId = 'transaction_id';
  static const errorMessage = 'error_message';

  static const reportContext = 'report_context';
}
