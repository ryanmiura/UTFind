import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utfind/services/api_service.dart';
import 'package:utfind/utils/token_manager.dart';

class LoginViewModel extends ChangeNotifier {
  String _ra = '';
  String _senha = '';
  bool _loading = false;
  String? _erro;

  String get ra => _ra;
  String get senha => _senha;
  bool get loading => _loading;
  String? get erro => _erro;

  void setRa(String value) {
    _ra = value;
    notifyListeners();
  }

  void setSenha(String value) {
    _senha = value;
    notifyListeners();
  }

  Future<bool> autenticar() async {
    _loading = true;
    _erro = null;
    notifyListeners();

    final apiService = ApiService();
    try {
      await apiService.login(_ra, _senha);
      _loading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _loading = false;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        _erro = 'Erro de conexão: ${e.message}';
      } else if (e.response?.statusCode == 401) {
        _erro = 'R.A. ou senha inválidos (401)';
      } else {
        _erro = 'Erro API (${e.response?.statusCode}): ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _loading = false;
      _erro = 'Erro inesperado: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> tryAutomaticLogin() async {
    _loading = true;
    _erro = null;
    notifyListeners();

    final credenciais = await TokenManager.getCredentials();
    if (credenciais == null) {
      _loading = false;
      notifyListeners();
      return false;
    }

    final apiService = ApiService();
    try {
      await apiService.login(credenciais['ra']!, credenciais['password']!);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Falha silenciosa ou token expirado
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  void limparErro() {
    _erro = null;
    notifyListeners();
  }
}
