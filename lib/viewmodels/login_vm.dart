import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utfind/services/api_service.dart';

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
    } catch (e) {
      _loading = false;
      _erro = 'R.A. ou senha inválidos';
      notifyListeners();
      return false;
    }
  }

  void limparErro() {
    _erro = null;
    notifyListeners();
  }
}