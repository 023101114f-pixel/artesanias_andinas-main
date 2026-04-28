// ============================================================================
//  features/favorites/domain/usecases/get_favorites_usecase.dart
// ============================================================================
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

class GetFavoritesUseCase implements UseCase<List<FavoriteEntity>, NoParams> {
  final FavoriteRepository repository;
  const GetFavoritesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<FavoriteEntity>>> call(NoParams params) =>
      repository.getFavorites();
}
