// ============================================================================
//  features/products/data/datasources/product_remote_datasource.dart
//
//  FUENTE DE DATOS REMOTA — Capa Data
//  Se comunica con la API REST usando Dio.
//  Solo trabaja con ProductModel, nunca con ProductEntity.
// ============================================================================

import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

/// Contrato de la fuente de datos remota
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
  Future<ProductModel> fetchProductById(int id);
}

/// Implementación concreta que usa Dio + FakeStore API
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio client;

  const ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await client.get('/products');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Error al obtener productos',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error de red',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ProductModel> fetchProductById(int id) async {
    try {
      final response = await client.get('/products/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Producto #$id no encontrado',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error de red',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
