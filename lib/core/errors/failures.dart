// ============================================================================
//  core/errors/failures.dart
//
//  Jerarquía de Failures (Fallos) para manejo funcional de errores.
//  Se usa con el tipo Either<Failure, T> del paquete dartz.
//
//  PATRÓN: En lugar de lanzar excepciones que "revientan" el flujo,
//  los repositorios retornan Either<Failure, T>:
//    - Left(ServerFailure())  → algo salió mal
//    - Right(data)            → éxito con datos
// ============================================================================

import 'package:equatable/equatable.dart';

/// Clase base abstracta para todos los fallos de la aplicación
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Fallo en la comunicación con el servidor / API
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Fallo de conexión a internet
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sin conexión a internet'});
}

/// Fallo en la base de datos local
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

/// Recurso no encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Recurso no encontrado'});
}

/// Error de autenticación
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Error de validación de datos
class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
  });
}

/// Error desconocido / inesperado
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Error inesperado'});
}
