// ============================================================================
//  features/products/presentation/controllers/product_controller.dart
//
//  CONTROLADOR — Capa Presentation
//  Usa Riverpod para gestión de estado reactivo.
//  Invoca los Use Cases inyectados por get_it.
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';

// ── Provider de lista de productos ────────────────────────────────────────
final productListProvider =
    AsyncNotifierProvider<ProductListController, List<ProductEntity>>(
  ProductListController.new,
);

class ProductListController
    extends AsyncNotifier<List<ProductEntity>> {

  late final GetProductsUseCase _getProducts;

  @override
  Future<List<ProductEntity>> build() async {
    // get_it proporciona la instancia ya configurada
    _getProducts = sl<GetProductsUseCase>();
    return _loadProducts();
  }

  Future<List<ProductEntity>> _loadProducts() async {
    final result = await _getProducts(NoParams());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (products) => products,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadProducts);
  }
}

// ── Provider de búsqueda ──────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    AsyncNotifierProvider<SearchController, List<ProductEntity>>(
  SearchController.new,
);

class SearchController extends AsyncNotifier<List<ProductEntity>> {
  late final SearchProductsUseCase _searchProducts;

  @override
  Future<List<ProductEntity>> build() async {
    _searchProducts = sl<SearchProductsUseCase>();
    return [];
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    final result = await _searchProducts(SearchProductsParams(query: query));
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (products) => AsyncValue.data(products),
    );
  }
}

// ── Provider de detalle de producto ───────────────────────────────────────
final productDetailProvider = AsyncNotifierProviderFamily<
    ProductDetailController, ProductEntity, int>(
  ProductDetailController.new,
);

class ProductDetailController
    extends FamilyAsyncNotifier<ProductEntity, int> {
  late final GetProductDetailUseCase _getDetail;

  @override
  Future<ProductEntity> build(int id) async {
    _getDetail = sl<GetProductDetailUseCase>();
    final result = await _getDetail(GetProductDetailParams(id: id));
    return result.fold(
      (failure) => throw Exception(failure.message),
      (product) => product,
    );
  }
}
