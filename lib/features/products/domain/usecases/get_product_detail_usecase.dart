// ============================================================================
//  features/products/domain/usecases/get_product_detail_usecase.dart
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductDetailParams {
  final int id;
  const GetProductDetailParams({required this.id});
}

/// Caso de Uso: Obtener detalle de un producto por ID
class GetProductDetailUseCase
    implements UseCase<ProductEntity, GetProductDetailParams> {
  final ProductRepository repository;

  const GetProductDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductDetailParams params) {
    return repository.getProductById(params.id);
  }
}
