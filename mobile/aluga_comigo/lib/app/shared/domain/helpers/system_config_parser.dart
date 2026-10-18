import '../entities/system_config.dart';
import '../entities/system_config_entry.dart';

abstract final class SystemConfigParser {
  static SystemConfig fromEntries(List<SystemConfigEntry> entries) {
    final map = {for (final e in entries) e.key: e};
    return SystemConfig(
      appActive: _bool(map['app_active'], defaultValue: true),
      storeActive: _bool(map['store_active'], defaultValue: true),
      storePowerUpActive: _bool(map['store_powerup_active'], defaultValue: true),
      storeSuperStarActive: _bool(map['store_superstar_active'], defaultValue: true),
      storeSuperChatActive: _bool(map['store_superchat_active'], defaultValue: true),
    );
  }

  static bool _bool(SystemConfigEntry? entry, {required bool defaultValue}) {
    if (entry == null) return defaultValue;
    if (entry.type != 'bool') return defaultValue;
    final normalized = entry.value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
    return defaultValue;
  }
}
