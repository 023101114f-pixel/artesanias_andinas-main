// ============================================================================
//  features/products/data/repositories/product_repository_impl.dart
//
//  IMPLEMENTACIÓN del repositorio — Capa Data
//  ────────────────────────────────────────────────────────────────────────
//  CONCEPTO: Implementa el contrato definido en Domain.
//  Decide la ESTRATEGIA de datos:
//    1. Intenta obtener de la red (Remote DataSource)
//    2. Guarda en caché local
//    3. Si falla la red, usa el caché (Offline-First)
//
//  Captura Exceptions (Data) → las convierte en Failures (Domain).
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  const ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      // 1. Intentar obtener de la API
      final remoteProducts = await remoteDataSource.fetchProducts();
      // 2. Guardar en caché local para uso offline
      await localDataSource.cacheProducts(remoteProducts);
      // 3. Convertir modelos → entidades y retornar éxito
      return Right(remoteProducts.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      // 4. Si la red falla, intentar el caché local
      try {
        final cached = await localDataSource.getCachedProducts();
        return Right(cached.map((m) => m.toEntity()).toList());
      } on CacheException {
        // 5. Sin red y sin caché → fallo definitivo
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      }
    } on CacheException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final model = await remoteDataSource.fetchProductById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      try {
        final cached = await localDataSource.getCachedProductById(id);
        return Right(cached.toEntity());
      } on CacheException {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      // Buscar primero en caché local (búsqueda offline)
      final cached = await localDataSource.getCachedProducts();
      final q = query.toLowerCase();
      final results = cached
          .where((m) =>
              m.name.toLowerCase().contains(q) ||
              m.description.toLowerCase().contains(q) ||
              m.artisan.toLowerCase().contains(q))
          .map((m) => m.toEntity())
          .toList();
      return Right(results);
    } on CacheException {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
      ProductCategory category) async {
    try {
      final cached = await localDataSource.getCachedProducts();
      final results = cached
          .where((m) =>
              ProductModel.fromEntity(
                      m.toEntity().copyWith(category: category))
                  .category ==
              category.name)
          .map((m) => m.toEntity())
          .toList();
      return Right(results);
    } on CacheException {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, void>> cacheProducts(
      List<ProductEntity> products) async {
    try {
      final models = products.map(ProductModel.fromEntity).toList();
      await localDataSource.cacheProducts(models);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }
}
