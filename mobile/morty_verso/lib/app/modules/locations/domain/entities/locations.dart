import '../../../../core/domain/entities/info_assistant.dart';
import 'location.dart';

class Locations {
  final InfoAssistant? info;
  final List<Location>? results;

  const Locations({
    this.info,
    this.results,
  });
}
