import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  /// Salva o token JWT de forma segura.
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Recupera o token JWT salvo, ou retorna null se não existir.
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Remove o token JWT salvo.
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}