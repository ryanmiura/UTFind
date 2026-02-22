import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _courseIdKey = 'course_id';
  static const _raKey = 'ra';
  static const _passwordKey = 'password';

  /// Salva as credenciais do usuário.
  static Future<void> saveCredentials(String ra, String password) async {
    await _storage.write(key: _raKey, value: ra);
    await _storage.write(key: _passwordKey, value: password);
  }

  /// Recupera as credenciais salvas. Retorna um mapa com 'ra' e 'password', ou nulo se não existirem.
  static Future<Map<String, String>?> getCredentials() async {
    final ra = await _storage.read(key: _raKey);
    final password = await _storage.read(key: _passwordKey);

    if (ra != null && password != null) {
      return {'ra': ra, 'password': password};
    }
    return null;
  }

  /// Remove as credenciais salvas.
  static Future<void> deleteCredentials() async {
    await _storage.delete(key: _raKey);
    await _storage.delete(key: _passwordKey);
  }

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

  /// Salva o ID do curso.
  static Future<void> saveCourseId(String courseId) async {
    await _storage.write(key: _courseIdKey, value: courseId);
  }

  /// Recupera o ID do curso salvo.
  static Future<String?> getCourseId() async {
    return await _storage.read(key: _courseIdKey);
  }

  /// Remove o ID do curso salvo.
  static Future<void> deleteCourseId() async {
    await _storage.delete(key: _courseIdKey);
  }
}
