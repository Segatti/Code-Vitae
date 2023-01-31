import '../../../../core/domain/entities/info_assistant.dart';
import 'episode.dart';

class Episodes {
  final InfoAssistant? info;
  final List<Episode>? results;

  const Episodes({
    this.info,
    this.results,
  });
}
