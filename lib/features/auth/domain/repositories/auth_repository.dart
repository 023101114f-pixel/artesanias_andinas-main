// ============================================================================
//  features/auth/domain/repositories/auth_repository.dart
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthEntity?>> getCurrentUser();
}
