import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/campus_unit.dart';
import '../services/api_service.dart';

enum UnitsLoadingState { initial, loading, loaded, error }

class UnitsViewModel extends ChangeNotifier {
  final ApiService _apiService;

  UnitsLoadingState _state = UnitsLoadingState.initial;
  String? _errorMessage;
  List<CampusUnit> _units = [];

  UnitsViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  UnitsLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  List<CampusUnit> get units => _units;

  Future<void> loadUnits({bool forceRefresh = false}) async {
    if (_state == UnitsLoadingState.loading) return;

    // Retorna os dados em cache se não for forceRefresh
    if (!forceRefresh && _units.isNotEmpty) {
      if (_state != UnitsLoadingState.loaded) {
        _state = UnitsLoadingState.loaded;
        notifyListeners();
      }
      return;
    }

    _state = UnitsLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getUnits();
      
      if (response.data != null && response.data is List) {
        final list = response.data as List;
        _units = list.map((e) => CampusUnit.fromJson(e)).toList();
      }

      _state = UnitsLoadingState.loaded;
    } on DioException catch (e) {
      _state = UnitsLoadingState.error;
      _errorMessage = 'Erro ao carregar unidades: ${e.message}';
    } catch (e) {
      _state = UnitsLoadingState.error;
      _errorMessage = 'Erro inesperado: $e';
    } finally {
      notifyListeners();
    }
  }
}
