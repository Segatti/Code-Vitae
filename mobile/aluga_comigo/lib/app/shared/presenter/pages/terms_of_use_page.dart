import 'package:material_ui/material_ui.dart';

import '../../domain/constants/terms_of_use_catalog.dart';
import 'legal_markdown_page.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return LegalMarkdownPage(
      appBarTitle: 'Termos de Uso (v$version)',
      assetPath: TermsOfUseCatalog.assetPathForVersion(version),
      loadErrorMessage: 'Não foi possível carregar os Termos de Uso.',
    );
  }
}
