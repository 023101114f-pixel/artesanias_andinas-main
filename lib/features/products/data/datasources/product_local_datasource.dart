// ============================================================================
//  features/products/data/datasources/product_local_datasource.dart
//
//  FUENTE DE DATOS LOCAL — Capa Data
//  Caché de productos en SQLite para modo Offline-First.
// ============================================================================

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<ProductModel> getCachedProductById(int id);
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final AppDatabase database;

  const ProductLocalDataSourceImpl({required this.database});

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final maps = await database.database.query('cached_products');
      if (maps.isEmpty) {
        throw const CacheException(message: 'No hay productos en caché');
      }
      return maps.map((m) => ProductModel.fromMap(m)).toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> getCachedProductById(int id) async {
    try {
      final maps = await database.database.query(
        'cached_products',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) {
        throw CacheException(message: 'Producto #$id no encontrado en caché');
      }
      return ProductModel.fromMap(maps.first);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final batch = database.database.batch();
      batch.delete('cached_products');
      for (final product in products) {
        batch.insert('cached_products', product.toMap());
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw DatabaseException(message: 'Error al guardar caché: $e');
    }
  }
}
