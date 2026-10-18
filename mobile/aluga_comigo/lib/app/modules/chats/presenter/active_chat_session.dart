/// Conversa aberta na tela de chat (suprime push duplicado).
abstract final class ActiveChatSession {
  static String? openChatId;

  static void setOpenChat(String? chatId) {
    openChatId = chatId?.trim().isEmpty == true ? null : chatId;
  }
}
