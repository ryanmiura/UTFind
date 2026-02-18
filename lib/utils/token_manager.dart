import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _courseIdKey = 'course_id';

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