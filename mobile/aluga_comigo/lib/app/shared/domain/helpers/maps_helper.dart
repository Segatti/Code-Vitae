import 'package:url_launcher/url_launcher.dart';

class MapsHelper {
  static Future<bool> openLocation({
    required String cep,
    required String cityState,
  }) async {
    final query = Uri.encodeComponent(
      [cep, cityState].where((part) => part.trim().isNotEmpty).join(', '),
    );
    if (query.isEmpty) return false;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
