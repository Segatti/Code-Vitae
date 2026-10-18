import '../../domain/entities/system_config_entry.dart';

class SystemConfigEntryModel {
  final String key;
  final String type;
  final String value;

  const SystemConfigEntryModel({
    required this.key,
    required this.type,
    required this.value,
  });

  factory SystemConfigEntryModel.fromMap(Map<String, dynamic> map) {
    return SystemConfigEntryModel(
      key: map['key']?.toString() ?? '',
      type: map['type']?.toString() ?? 'string',
      value: map['value']?.toString() ?? '',
    );
  }

  SystemConfigEntry toEntity() => SystemConfigEntry(
    key: key,
    type: type,
    value: value,
  );
}
