import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const _keyFav = 'favorite_ids';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFav) ?? [];
  }

  static Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyFav) ?? [];
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    await prefs.setStringList(_keyFav, list);
  }

  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyFav) ?? [];
    return list.contains(id);
  }
}
