import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/ru_meal.dart';
import '../services/api_service.dart';

enum RULoadingState { initial, loading, loaded, error }

class RUExtractViewModel extends ChangeNotifier {
  final ApiService _apiService;

  RULoadingState _state = RULoadingState.initial;
  String? _errorMessage;
  List<RUMeal> _allMeals = []; // Lista original completa
  List<RUMeal> _meals = []; // Lista filtrada
  Map<String, List<RUMeal>> _groupedMeals = {};
  double _totalSpent = 0.0;
  double _totalSubsidy = 0.0;
  int _totalMeals = 0;
  
  // Estatísticas
  int _lunchCount = 0;
  int _dinnerCount = 0;

  // Filtro
  String _filterType = 'Todos'; // Todos, Almoço, Jantar

  RUExtractViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  RULoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  List<RUMeal> get meals => _meals;
  Map<String, List<RUMeal>> get groupedMeals => _groupedMeals;
  double get totalSpent => _totalSpent;
  double get totalSubsidy => _totalSubsidy;
  int get totalMeals => _totalMeals;
  int get lunchCount => _lunchCount;
  int get dinnerCount => _dinnerCount;
  String get filterType => _filterType;

  Future<void> loadMeals() async {
    if (_state == RULoadingState.loading) return;

    _state = RULoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getRUMeals();
      
      if (response.data != null && response.data is List) {
        final list = response.data as List;
        _allMeals = list.map((e) => RUMeal.fromJson(e)).toList();
        
        // Ordenar por data (decrescente)
        _allMeals.sort((a, b) => b.date.compareTo(a.date));

        // Calcular estatísticas globais
        _calculateStats();

        // Aplicar filtro inicial (Todos) e agrupar
        _applyFilter();
      }

      _state = RULoadingState.loaded;
    } on DioException catch (e) {
      _state = RULoadingState.error;
      _errorMessage = 'Erro ao carregar extrato: ${e.message}';
    } catch (e) {
      _state = RULoadingState.error;
      _errorMessage = 'Erro inesperado: $e';
    } finally {
      notifyListeners();
    }
  }

  void setFilter(String type) {
    if (_filterType == type) return;
    _filterType = type;
    _applyFilter();
    notifyListeners();
  }

  void _calculateStats() {
    _totalSpent = 0.0;
    _totalSubsidy = 0.0;
    _totalMeals = _allMeals.length;
    _lunchCount = 0;
    _dinnerCount = 0;

    for (var meal in _allMeals) {
      _totalSpent += meal.paidAmount;
      _totalSubsidy += meal.subsidyAmount;
      
      if (meal.type.toLowerCase().contains('almoço')) {
        _lunchCount++;
      } else if (meal.type.toLowerCase().contains('jantar')) {
        _dinnerCount++;
      }
    }
  }

  void _applyFilter() {
    if (_filterType == 'Todos') {
      _meals = List.from(_allMeals);
    } else {
      _meals = _allMeals.where((m) => m.type.toLowerCase().contains(_filterType.toLowerCase())).toList();
    }

    // Reagrupar com base na lista filtrada
    _groupedMeals = {};
    for (var meal in _meals) {
      final key = '${_getMonthName(meal.date.month)}/${meal.date.year}';
      if (!_groupedMeals.containsKey(key)) {
        _groupedMeals[key] = [];
      }
      _groupedMeals[key]!.add(meal);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }
}
