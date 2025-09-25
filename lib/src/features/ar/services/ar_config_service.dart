import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ar_target_model.dart';

class ARConfigService {
  static const String _configPath = 'assets/ar_config/ar_targets.json';
  static ARTargetsConfig? _cachedConfig;

  static Future<ARTargetsConfig> loadConfig() async {
    if (_cachedConfig != null) {
      return _cachedConfig!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_configPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedConfig = ARTargetsConfig.fromJson(jsonData);
      return _cachedConfig!;
    } catch (e) {
      throw Exception('Failed to load AR config: $e');
    }
  }

  static Future<ARTarget?> getTargetById(String id) async {
    final config = await loadConfig();
    try {
      return config.targets.firstWhere((target) => target.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<ARTarget>> getAllTargets() async {
    final config = await loadConfig();
    return config.targets;
  }
}

