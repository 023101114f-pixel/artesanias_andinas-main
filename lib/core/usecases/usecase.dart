// ============================================================================
//  core/usecases/usecase.dart
//
//  Interfaz genérica para todos los Use Cases.
//  Aplica Interface Segregation + Single Responsibility.
//
//  UseCase<Type, Params>:
//    - Type:   tipo de dato que retorna el caso de uso
//    - Params: parámetros de entrada (usar NoParams si no hay)
// ============================================================================

import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Contrato base para todos los casos de uso
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Usar cuando el caso de uso no requiere parámetros
class NoParams {}
