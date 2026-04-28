// ============================================================================
//  features/products/presentation/pages/product_list_page.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/category_filter_bar.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artesanías Andinas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => context.go('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          const CategoryFilterBar(),
          Expanded(
            child: productsState.when(
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando artesanías...'),
                  ],
                ),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () =>
                          ref.read(productListProvider.notifier).refresh(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
              data: (products) => products.isEmpty
                  ? const Center(child: Text('No se encontraron productos'))
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(productListProvider.notifier).refresh(),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: products.length,
                        itemBuilder: (ctx, i) => ProductCard(
                          product: products[i],
                          onTap: () =>
                              context.go('/products/${products[i].id}'),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearch(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: _ProductSearchDelegate(ref),
    );
  }
}

class _ProductSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;
  _ProductSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(child: Text('Escribe algo para buscar'));
    }
    // ✅ Fix: pospone la modificación del provider hasta después del build
    Future.microtask(
        () => ref.read(searchResultsProvider.notifier).search(query.trim()));
    return _buildResultsList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().length < 3) {
      return const Center(
        child: Text('Escribe al menos 3 caracteres'),
      );
    }
    // ✅ Fix: pospone la modificación del provider hasta después del build
    Future.microtask(
        () => ref.read(searchResultsProvider.notifier).search(query.trim()));
    return _buildResultsList(context);
  }

  Widget _buildResultsList(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (products) => products.isEmpty
          ? const Center(child: Text('Sin resultados'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, i) => ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: Text(products[i].name),
                subtitle: Text(products[i].formattedPrice),
                onTap: () {
                  close(context, '');
                  context.go('/products/${products[i].id}');
                },
              ),
            ),
    );
  }
}
