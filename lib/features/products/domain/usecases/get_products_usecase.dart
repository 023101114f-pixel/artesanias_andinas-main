// ============================================================================
//  features/products/domain/usecases/get_products_usecase.dart
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Caso de Uso: Obtener lista de productos (con lógica offline-first)
class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;

  const GetProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) {
    return repository.getProducts();
  }
}
