import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/history_entry.dart';
import '../services/api_service.dart';

enum HistoryLoadingState { initial, loading, loaded, error }

class HistoryViewModel extends ChangeNotifier {
  final ApiService _apiService;

  HistoryLoadingState _state = HistoryLoadingState.initial;
  String? _errorMessage;
  List<HistoryEntry> _history = [];
  Map<String, List<HistoryEntry>> _groupedHistory = {};

  HistoryViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  HistoryLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  List<HistoryEntry> get history => _history;
  Map<String, List<HistoryEntry>> get groupedHistory => _groupedHistory;

  Future<void> loadHistory({bool forceRefresh = false}) async {
    if (_state == HistoryLoadingState.loading) return;

    // Retorna os dados em cache se não for forceRefresh
    if (!forceRefresh && _history.isNotEmpty) {
      if (_state != HistoryLoadingState.loaded) {
        _state = HistoryLoadingState.loaded;
        notifyListeners();
      }
      return;
    }

    _state = HistoryLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getHistory();
      
      if (response.data != null && response.data is List) {
        final list = response.data as List;
        _history = list.map((e) => HistoryEntry.fromJson(e)).toList();
        
        // Ordenar por ano e semestre (decrescente)
        _history.sort((a, b) {
          if (b.year != a.year) {
            return b.year.compareTo(a.year);
          }
          return b.semester.compareTo(a.semester);
        });

        // Agrupar por semestre (Label)
        _groupedHistory = {};
        for (var entry in _history) {
          final key = entry.semesterLabel;
          if (!_groupedHistory.containsKey(key)) {
            _groupedHistory[key] = [];
          }
          _groupedHistory[key]!.add(entry);
        }
      }

      _state = HistoryLoadingState.loaded;
    } on DioException catch (e) {
      _state = HistoryLoadingState.error;
      _errorMessage = 'Erro ao carregar histórico: ${e.message}';
    } catch (e) {
      _state = HistoryLoadingState.error;
      _errorMessage = 'Erro inesperado: $e';
    } finally {
      notifyListeners();
    }
  }
}
