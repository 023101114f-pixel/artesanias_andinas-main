// ============================================================================
//  features/favorites/domain/repositories/favorite_repository.dart
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(int productId, String productName);
  Future<Either<Failure, void>> removeFavorite(int productId);
  Future<Either<Failure, bool>> isFavorite(int productId);
}
