import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/ru_meal.dart';
import '../services/api_service.dart';

enum RULoadingState { initial, loading, loaded, error }

class RUExtractViewModel extends ChangeNotifier {
  final ApiService _apiService;

  RULoadingState _state = RULoadingState.initial;
  String? _errorMessage;
  List<RUMeal> _meals = [];
  Map<String, List<RUMeal>> _groupedMeals = {};
  double _totalSpent = 0.0;
  double _totalSubsidy = 0.0;
  int _totalMeals = 0;

  RUExtractViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  RULoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  List<RUMeal> get meals => _meals;
  Map<String, List<RUMeal>> get groupedMeals => _groupedMeals;
  double get totalSpent => _totalSpent;
  double get totalSubsidy => _totalSubsidy;
  int get totalMeals => _totalMeals;

  Future<void> loadMeals() async {
    if (_state == RULoadingState.loading) return;

    _state = RULoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getRUMeals();
      
      if (response.data != null && response.data is List) {
        final list = response.data as List;
        _meals = list.map((e) => RUMeal.fromJson(e)).toList();
        
        // Ordenar por data (decrescente)
        _meals.sort((a, b) => b.date.compareTo(a.date));

        // Calcular totais
        _totalSpent = 0.0;
        _totalSubsidy = 0.0;
        _totalMeals = _meals.length;

        for (var meal in _meals) {
          _totalSpent += meal.paidAmount;
          _totalSubsidy += meal.subsidyAmount;
        }

        // Agrupar por Mês/Ano (ex: "Janeiro/2023")
        _groupedMeals = {};
        for (var meal in _meals) {
          final key = '${_getMonthName(meal.date.month)}/${meal.date.year}';
          if (!_groupedMeals.containsKey(key)) {
            _groupedMeals[key] = [];
          }
          _groupedMeals[key]!.add(meal);
        }
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

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }
}
