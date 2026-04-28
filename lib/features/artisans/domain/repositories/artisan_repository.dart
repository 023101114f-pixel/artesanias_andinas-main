import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/artisan_entity.dart';

abstract class ArtisanRepository {
  Future<Either<Failure, List<ArtisanEntity>>> getArtisans();
  Future<Either<Failure, ArtisanEntity>> getArtisanById(int id);
  Future<Either<Failure, List<ArtisanEntity>>> getArtisansBySpecialty(
    Specialty specialty,
  );
}
