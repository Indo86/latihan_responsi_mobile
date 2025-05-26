import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyLoggedIn    = 'isLoggedIn';
  static const _keyEmail       = 'user_email';
  static const _keyPassword    = 'user_password';

  /// Simpan user baru. Return false jika email sudah terdaftar.
  static Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_keyEmail)) return false;
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
    // Jangan auto-login
    await prefs.setBool(_keyLoggedIn, false);
    return true;
  }

  /// Validasi credential. Return true jika cocok & set loggedIn.
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_keyEmail);
    final storedPass  = prefs.getString(_keyPassword);
    if (email == storedEmail && password == storedPass) {
      await prefs.setBool(_keyLoggedIn, true);
      return true;
    }
    return false;
  }

  /// Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, false);
  }

  /// Cek status login
  static Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }
}
