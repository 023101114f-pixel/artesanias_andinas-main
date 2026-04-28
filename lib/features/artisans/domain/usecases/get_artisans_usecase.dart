import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/artisan_entity.dart';
import '../repositories/artisan_repository.dart';

class GetArtisansUseCase implements UseCase<List<ArtisanEntity>, NoParams> {
  final ArtisanRepository repository;

  const GetArtisansUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ArtisanEntity>>> call(NoParams params) {
    return repository.getArtisans();
  }
}
