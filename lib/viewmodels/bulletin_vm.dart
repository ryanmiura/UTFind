import 'package:flutter/material.dart';
import 'package:utfind/models/bulletin_model.dart';
import 'package:utfind/services/api_service.dart';

class BulletinViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<BulletinSubject> _subjects = [];
  bool _isLoading = false;
  String? _error;

  List<BulletinSubject> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBulletin() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getBulletin();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _subjects = data.map((json) => BulletinSubject.fromJson(json)).toList();
      } else {
        _error = "Erro ao carregar boletim: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Falha na conexão: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
