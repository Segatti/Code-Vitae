enum UserReportContext {
  profile,
  chat,
  listing;

  String get storageValue => name;

  String get analyticsValue => name;

  String get label => switch (this) {
        UserReportContext.profile => 'Perfil',
        UserReportContext.chat => 'Conversa',
        UserReportContext.listing => 'Anúncio',
      };
}
