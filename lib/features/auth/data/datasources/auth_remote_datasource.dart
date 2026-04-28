// ============================================================================
//  features/auth/data/datasources/auth_remote_datasource.dart
//
//  FUENTE DE DATOS REMOTA de autenticación.
//  Usa FakeStore API /auth/login para demostración.
//  En producción: reemplazar con Firebase Auth o backend propio.
// ============================================================================

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;
  const AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      // FakeStore API espera username+password (simulamos con email)
      final response = await client.post(
        '/auth/login',
        data: {
          'username': email.split('@').first, // simplificado para demo
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        // FakeStore devuelve solo token; completamos con datos del usuario
        return AuthModel(
          id: '1',
          name: email.split('@').first,
          email: email,
          role: 'customer',
          token: data['token'] as String? ?? 'demo_token_${email.hashCode}',
        );
      } else {
        throw ServerException(
          message: 'Credenciales incorrectas',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Para fines de demo con FakeStore, si falla la red generamos token local
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        // Modo demo offline
        return AuthModel(
          id: 'demo_${email.hashCode}',
          name: email.split('@').first,
          email: email,
          role: 'customer',
          token: 'offline_token_${email.hashCode}',
        );
      }
      throw ServerException(
        message: e.message ?? 'Error de autenticación',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout() async {
    // En una API real enviaríamos un request de logout
    // Para FakeStore API no existe endpoint de logout
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
