// ============================================================================
//  features/favorites/domain/usecases/add_favorite_usecase.dart
// ============================================================================
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorite_repository.dart';

class AddFavoriteParams {
  final int productId;
  final String productName;
  const AddFavoriteParams({required this.productId, required this.productName});
}

class AddFavoriteUseCase implements UseCase<void, AddFavoriteParams> {
  final FavoriteRepository repository;
  const AddFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(AddFavoriteParams params) =>
      repository.addFavorite(params.productId, params.productName);
}

// ============================================================================
//  features/favorites/domain/usecases/remove_favorite_usecase.dart
// ============================================================================
class RemoveFavoriteParams {
  final int productId;
  const RemoveFavoriteParams({required this.productId});
}

class RemoveFavoriteUseCase implements UseCase<void, RemoveFavoriteParams> {
  final FavoriteRepository repository;
  const RemoveFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RemoveFavoriteParams params) =>
      repository.removeFavorite(params.productId);
}
