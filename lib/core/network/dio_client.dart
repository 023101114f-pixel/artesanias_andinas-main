// ============================================================================
//  core/network/dio_client.dart
//
//  Configuración del cliente HTTP Dio.
//  Se registra como LazySingleton en el contenedor IoC.
// ============================================================================

import 'package:dio/dio.dart';

class DioClient {
  /// URL base de la API pública de ejemplo (Open Food Facts adaptado)
  /// En producción, reemplazar con la URL real del backend.
  static const String _baseUrl = 'https://fakestoreapi.com';

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor de logging (solo en modo debug)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }
}
