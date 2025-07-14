import 'package:flutter/material.dart';

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

    // Simulação de autenticação
    await Future.delayed(const Duration(seconds: 2));

    // Exemplo: aceita ra e senha 123
  if (_ra == "123" && _senha == "123") {
      _loading = false;
      notifyListeners();
      return true;
    } else {
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