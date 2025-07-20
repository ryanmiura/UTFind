import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:utfind/utils/token_manager.dart';

class ApiService {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  final Dio _dio;

  // Token JWT opcional (não utilizado ainda)
  String? jwtToken;

  ApiService({this.jwtToken})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    // Interceptor para inserir JWT e lidar com expiração
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenManager.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await TokenManager.deleteToken();
          }
          handler.next(error);
        },
      ),
    );
  }

  /// Método genérico para requisições GET.
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: _buildOptions(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Método genérico para requisições PUT
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        options: _buildOptions(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Realiza autenticação (login) via PUT em /auth..
  Future<Response> login(String username, String password) async {
    try {
      const String endpoint = '/auth';

      final data = {
        'username': username,
        'password': password,
      };

      final response = await Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      )).put(
        endpoint,
        data: data,
      );

      // Salva o token JWT imediatamente após login bem-sucedido
      final token = response.data['token'];
      if (token != null && token is String && token.isNotEmpty) {
        await TokenManager.saveToken(token);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }



  // Monta as opções de requisição, incluindo o header Authorization se o token estiver presente.
  Options _buildOptions() {
    final headers = <String, dynamic>{};
    if (jwtToken != null && jwtToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $jwtToken';
    }
    return Options(headers: headers);
  }
}