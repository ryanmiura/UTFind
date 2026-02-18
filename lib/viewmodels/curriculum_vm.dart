import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/curriculum_subject.dart';
import '../models/history_entry.dart';
import '../services/api_service.dart';

enum CurriculumLoadingState { initial, loading, loaded, error }

class CurriculumViewModel extends ChangeNotifier {
  final ApiService _apiService;

  CurriculumLoadingState _state = CurriculumLoadingState.initial;
  String? _errorMessage;
  List<CurriculumSubject> _curriculum = [];
  Map<int, List<CurriculumSubject>> _groupedCurriculum = {};
  double _progress = 0.0;
  int _totalHours = 0;
  int _completedHours = 0;

  CurriculumViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  CurriculumLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  List<CurriculumSubject> get curriculum => _curriculum;
  Map<int, List<CurriculumSubject>> get groupedCurriculum => _groupedCurriculum;
  double get progress => _progress;
  int get totalHours => _totalHours;
  int get completedHours => _completedHours;

  Future<void> loadCurriculum() async {
    if (_state == CurriculumLoadingState.loading) return;

    _state = CurriculumLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Carregar Matriz e Histórico em paralelo
      final results = await Future.wait([
        _apiService.getCurriculum(),
        _apiService.getHistory(),
      ]);

      final matrixResponse = results[0];
      final historyResponse = results[1];

      // Processar Matriz
      if (matrixResponse.data != null && matrixResponse.data is List) {
        final list = matrixResponse.data as List;
        _curriculum = list.map((e) => CurriculumSubject.fromJson(e)).toList();
      }

      // Processar Histórico para marcar completas
      final Set<String> approvedSubjects = {};
      if (historyResponse.data != null && historyResponse.data is List) {
        final list = historyResponse.data as List;
        for (var item in list) {
          final entry = HistoryEntry.fromJson(item);
          if (entry.isApproved) {
            approvedSubjects.add(entry.subjectName.toLowerCase().trim());
          }
        }
      }

      // Cruzar dados e calcular progresso
      _totalHours = 0;
      _completedHours = 0;
      final List<CurriculumSubject> updatedList = [];

      for (var subject in _curriculum) {
        final isApproved = approvedSubjects.contains(subject.name.toLowerCase().trim());
        final updatedSubject = subject.copyWith(isCompleted: isApproved);
        updatedList.add(updatedSubject);

        _totalHours += subject.totalHours;
        if (isApproved) {
          _completedHours += subject.totalHours;
        }
      }

      _curriculum = updatedList;
      _progress = _totalHours > 0 ? _completedHours / _totalHours : 0.0;

      // Agrupar por período
      _groupedCurriculum = {};
      for (var subject in _curriculum) {
        if (!_groupedCurriculum.containsKey(subject.period)) {
          _groupedCurriculum[subject.period] = [];
        }
        _groupedCurriculum[subject.period]!.add(subject);
      }
      
      // Ordenar chaves
      final sortedKeys = _groupedCurriculum.keys.toList()..sort();
      final Map<int, List<CurriculumSubject>> sortedGrouped = {};
      for (var key in sortedKeys) {
        sortedGrouped[key] = _groupedCurriculum[key]!;
      }
      _groupedCurriculum = sortedGrouped;

      _state = CurriculumLoadingState.loaded;
    } on DioException catch (e) {
      _state = CurriculumLoadingState.error;
      _errorMessage = 'Erro ao carregar matriz curricular: ${e.message}';
    } catch (e) {
      _state = CurriculumLoadingState.error;
      _errorMessage = 'Erro inesperado: $e';
    } finally {
      notifyListeners();
    }
  }
}
