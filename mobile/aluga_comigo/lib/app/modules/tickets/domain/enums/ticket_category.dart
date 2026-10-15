enum TicketCategory {
  suggestion,
  bug,
  complaint,
  report;

  String get label => switch (this) {
    TicketCategory.suggestion => 'Sugestões',
    TicketCategory.bug => 'Bugs',
    TicketCategory.complaint => 'Reclamações',
    TicketCategory.report => 'Denuncia',
  };

  String get storageValue => name;

  static TicketCategory fromStorage(String value) {
    return TicketCategory.values.firstWhere(
      (item) => item.name == value,
      orElse: () => TicketCategory.suggestion,
    );
  }
}
