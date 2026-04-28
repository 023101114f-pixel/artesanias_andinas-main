// ============================================================================
//  features/products/domain/usecases/search_products_usecase.dart
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class SearchProductsParams {
  final String query;
  const SearchProductsParams({required this.query});
}

/// Caso de Uso: Buscar productos por nombre o descripción
class SearchProductsUseCase
    implements UseCase<List<ProductEntity>, SearchProductsParams> {
  final ProductRepository repository;

  const SearchProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
      SearchProductsParams params) {
    if (params.query.trim().isEmpty) {
      // Regla de negocio: query vacío retorna lista vacía
      return Future.value(const Right([]));
    }
    return repository.searchProducts(params.query.trim());
  }
}
