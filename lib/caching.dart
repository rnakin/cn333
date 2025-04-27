import 'package:shared_preferences/shared_preferences.dart';

class Caching {
  /// Saves a string to cache. Throws if key is empty or save fails.
  static Future<void> saveString({
    required String key,
    required String value,
  }) async {
    if (key.isEmpty) throw ArgumentError("Key cannot be empty");

    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(key, value);
      if (!success) throw Exception("Failed to save data");
    } catch (e) {
      throw Exception("Cache save failed: $e");
    }
  }

  /// Reads a string from cache. Returns `null` if key doesn't exist.
  static Future<String?> readString(String key) async {
    if (key.isEmpty) throw ArgumentError("Key cannot be empty");

    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key); // Returns `null` if key not found
    } catch (e) {
      throw Exception("Cache read failed: $e");
    }
  }

  /// Reads a string with a fallback default value.
  static Future<String> readStringWithDefault({
    required String key,
    String defaultValue = "",
  }) async {
    final value = await readString(key);
    return value ?? defaultValue;
  }

  /// Deletes a key from cache.
  static Future<bool> delete(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(key);
    } catch (e) {
      throw Exception("Cache delete failed: $e");
    }
  }

  /// Clears all cached data.
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      throw Exception("Cache clear failed: $e");
    }
  }
}