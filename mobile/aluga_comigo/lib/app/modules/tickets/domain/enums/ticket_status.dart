enum TicketStatus {
  open,
  closed;

  String get storageValue => name;

  static TicketStatus fromStorage(String value) {
    return TicketStatus.values.firstWhere(
      (item) => item.name == value,
      orElse: () => TicketStatus.open,
    );
  }

  bool get isOpen => this == TicketStatus.open;

  String get label => switch (this) {
    TicketStatus.open => 'Aberto',
    TicketStatus.closed => 'Finalizado',
  };
}
