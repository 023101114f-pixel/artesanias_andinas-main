// ============================================================================
//  core/errors/exceptions.dart
//
//  Excepciones de la capa DATA. Son distintas a los Failures:
//  - Exceptions: se lanzan en la capa Data (datasources / repositories)
//  - Failures:   se retornan en el Domain como Either<Failure, T>
//
//  El repositorio captura las excepciones y las convierte en Failures.
// ============================================================================

/// Excepción al recibir respuesta de error del servidor
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

/// Excepción cuando no hay conexión a internet
class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Sin conexión a internet'});
}

/// Excepción al interactuar con la base de datos local
class DatabaseException implements Exception {
  final String message;
  const DatabaseException({required this.message});
}

/// Excepción cuando el usuario no está autenticado
class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

/// Excepción de caché (dato no encontrado localmente)
class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Dato no encontrado en caché'});
}
