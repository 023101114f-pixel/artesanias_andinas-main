import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/artisan_entity.dart';
import '../../domain/repositories/artisan_repository.dart';
import '../datasources/artisan_remote_datasource.dart';

class ArtisanRepositoryImpl implements ArtisanRepository {
  final ArtisanRemoteDataSource remoteDataSource;

  const ArtisanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ArtisanEntity>>> getArtisans() async {
    try {
      final models = await remoteDataSource.getArtisans();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ArtisanEntity>> getArtisanById(int id) async {
    try {
      final model = await remoteDataSource.getArtisanById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ArtisanEntity>>> getArtisansBySpecialty(
    Specialty specialty,
  ) async {
    try {
      final models = await remoteDataSource.getArtisans();
      final filtered = models
          .where((m) => m.specialty == specialty)
          .map((m) => m.toEntity())
          .toList();
      return Right(filtered);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
