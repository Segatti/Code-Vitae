import 'package:material_ui/material_ui.dart';

import '../../domain/constants/privacy_policy_catalog.dart';
import 'legal_markdown_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return LegalMarkdownPage(
      appBarTitle: 'Política de Privacidade (v$version)',
      assetPath: PrivacyPolicyCatalog.assetPathForVersion(version),
      loadErrorMessage: 'Não foi possível carregar a Política de Privacidade.',
    );
  }
}
