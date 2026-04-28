// ============================================================================
//  features/auth/data/repositories/auth_repository_impl.dart
//
//  IMPLEMENTACIÓN del repositorio de autenticación.
//  En esta sesión usamos solo el RemoteDataSource.
//  La Unidad II (Lab 12) agregará almacenamiento seguro de tokens.
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

// Token en memoria para esta sesión (Lab 12 usará flutter_secure_storage)
AuthEntity? _cachedUser;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthEntity>> login(
      String email, String password) async {
    try {
      final model = await remoteDataSource.login(email, password);
      final entity = model.toEntity();
      _cachedUser = entity; // guardar sesión en memoria
      return Right(entity);
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      _cachedUser = null;
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    return Right(_cachedUser);
  }
}
