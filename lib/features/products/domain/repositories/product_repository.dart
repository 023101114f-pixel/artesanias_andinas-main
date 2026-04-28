// ============================================================================
//  features/products/domain/repositories/product_repository.dart
//
//  INTERFAZ de repositorio — Capa Domain
//  ────────────────────────────────────────────────────────────────────────
//  CONCEPTO: Dependency Inversion Principle (DIP)
//
//  Esta clase abstracta define el CONTRATO que la capa Data debe cumplir.
//  El Domain NO sabe si los datos vienen de una API REST, Firebase,
//  SQLite o un archivo JSON. Solo conoce este contrato.
//
//  RETORNA Either<Failure, T>:
//    - Left(Failure)  → algo salió mal (ver core/errors/failures.dart)
//    - Right(T)       → operación exitosa con datos
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';

/// Contrato de acceso a datos de productos.
/// La capa Data lo implementará; la capa Presentation nunca lo verá.
abstract class ProductRepository {

  /// Obtiene la lista completa de productos.
  /// Implementa offline-first: primero intenta la red, luego el caché.
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  /// Obtiene el detalle de un producto específico por su ID.
  Future<Either<Failure, ProductEntity>> getProductById(int id);

  /// Busca productos por nombre o descripción.
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);

  /// Filtra productos por categoría.
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    ProductCategory category,
  );

  /// Persiste la lista de productos en el caché local.
  Future<Either<Failure, void>> cacheProducts(List<ProductEntity> products);
}
