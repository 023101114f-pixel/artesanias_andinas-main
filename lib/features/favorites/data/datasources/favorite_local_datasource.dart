// ============================================================================
//  features/favorites/data/datasources/favorite_local_datasource.dart
// ============================================================================

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/favorite_model.dart';

abstract class FavoriteLocalDataSource {
  Future<List<FavoriteModel>> getFavorites();
  Future<void> addFavorite(int productId, String productName);
  Future<void> removeFavorite(int productId);
  Future<bool> isFavorite(int productId);
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final AppDatabase database;
  const FavoriteLocalDataSourceImpl({required this.database});

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final maps = await database.database.query(
        'favorites',
        orderBy: 'addedAt DESC',
      );
      return maps.map((m) => FavoriteModel.fromMap(m)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Error al obtener favoritos: $e');
    }
  }

  @override
  Future<void> addFavorite(int productId, String productName) async {
    try {
      await database.database.insert('favorites', {
        'productId': productId,
        'productName': productName,
        'addedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseException(message: 'Error al agregar favorito: $e');
    }
  }

  @override
  Future<void> removeFavorite(int productId) async {
    try {
      await database.database.delete(
        'favorites',
        where: 'productId = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      throw DatabaseException(message: 'Error al eliminar favorito: $e');
    }
  }

  @override
  Future<bool> isFavorite(int productId) async {
    final result = await database.database.query(
      'favorites',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }
}
