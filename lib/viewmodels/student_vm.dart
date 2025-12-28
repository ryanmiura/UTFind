import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/student.dart';
import '../services/api_service.dart';

enum StudentLoadingState {
  initial,
  loading,
  loaded,
  error,
}

/// ViewModel disponibilizado globalmente pelo MultiProvider
class StudentViewModel extends ChangeNotifier {
  final ApiService _apiService;
  
  StudentLoadingState _state = StudentLoadingState.initial;
  
  Student? _student;
  Uint8List? _photoBytes;
  String? _errorMessage;

  StudentViewModel({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  // Getters públicos
  StudentLoadingState get state => _state;
  Student? get student => _student;
  Uint8List? get photoBytes => _photoBytes;
  String? get errorMessage => _errorMessage;

  // Getters de conveniência para acesso rápido aos dados
  String get studentName => _student?.name ?? '';
  String get studentRa => _student?.ra ?? '';
  String get studentEmail => _student?.institutionalEmail ?? '';
  String get primaryCourseName => _student?.primaryCourseName ?? '';
  String get primaryCourseType => _student?.primaryCourseType ?? '';
  String get badgeValidity => _student?.badgeValidity ?? '';
  int get currentPeriod => _student?.currentPeriod ?? 0;
  double get academicCoefficient => _student?.academicCoefficient ?? 0.0;

  bool get hasData => _student != null;
  bool get hasPhoto => _photoBytes != null;

  /// Carrega todos os dados do estudante em paralelo
  Future<void> loadAllData() async {
    if (_state == StudentLoadingState.loading) return;

    _state = StudentLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getStudentData(),
        _apiService.getStudentPhoto(),
      ]);

      final studentDataResponse = results[0];
      final photoResponse = results[1];

      if (studentDataResponse.data != null) {
        _student = Student.fromJson(studentDataResponse.data as Map<String, dynamic>);
      } else {
        throw Exception('Dados do estudante vazios');
      }

      if (photoResponse.data != null && photoResponse.data is String) {
        final base64String = photoResponse.data as String;
        _photoBytes = base64Decode(base64String);
      } else {
        debugPrint('StudentViewModel: Foto não disponível');
      }

      _state = StudentLoadingState.loaded;
      _errorMessage = null;
    } on DioException catch (e) {
      _state = StudentLoadingState.error;
      _errorMessage = _handleDioError(e);
      debugPrint('StudentViewModel: Erro ao carregar dados - $_errorMessage');
    } catch (e) {
      _state = StudentLoadingState.error;
      _errorMessage = 'Erro inesperado ao carregar dados do estudante';
      debugPrint('StudentViewModel: Erro inesperado - $e');
    } finally {
      notifyListeners();
    }
  }

  /// usado no pull-to-refresh
  Future<void> reload() async {
    await loadAllData();
  }

  /// usado para logout
  void clear() {
    _state = StudentLoadingState.initial;
    _student = null;
    _photoBytes = null;
    _errorMessage = null;
    notifyListeners();
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tempo de conexão esgotado. Verifique sua internet.';
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return 'Sessão expirada. Faça login novamente.';
        } else if (statusCode == 404) {
          return 'Dados do estudante não encontrados.';
        } else if (statusCode == 500) {
          return 'Erro no servidor. Tente novamente mais tarde.';
        }
        return 'Erro ao buscar dados (código $statusCode).';
      
      case DioExceptionType.cancel:
        return 'Requisição cancelada.';
      
      case DioExceptionType.connectionError:
        return 'Sem conexão com a internet.';
      
      default:
        return 'Erro ao conectar com o servidor.';
    }
  }

  Course? get primaryCourse => _student?.primaryCourse;
  bool get hasActiveEnrollment => _student?.hasActiveEnrollment ?? false;
}
