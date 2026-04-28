// ============================================================================
//  features/products/presentation/pages/product_detail_page.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product_entity.dart';
import '../controllers/product_controller.dart';
import '../../../favorites/presentation/controllers/favorite_controller.dart';

class ProductDetailPage extends ConsumerWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productDetailProvider(productId));
    final favoritesState = ref.watch(favoritesProvider);

    return Scaffold(
      body: productState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (product) {
          final isFavorite = favoritesState.valueOrNull
                  ?.any((f) => f.productId == product.id) ??
              false;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    product.name,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: _buildImage(product.imageUrl),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () => _toggleFavorite(ref, product, isFavorite),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Precio y stock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.formattedPrice,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: const Color(0xFF8B4513),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Chip(
                            label: Text(product.stockStatus),
                            backgroundColor: product.isAvailable
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Categoría y premium
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(label: Text(product.category.label)),
                          if (product.isPremium)
                            const Chip(
                              label: Text('✦ Premium'),
                              backgroundColor: Color(0xFFFFF9C4),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Artesano y origen
                      _InfoRow(
                          icon: Icons.person,
                          label: 'Artesano',
                          value: product.artisan),
                      _InfoRow(
                          icon: Icons.location_on,
                          label: 'Origen',
                          value: product.origin),
                      const Divider(height: 32),

                      // Descripción
                      Text(
                        'Descripción',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),

                      // Botón de compra
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: product.isAvailable ? () {} : null,
                          icon: const Icon(Icons.shopping_cart),
                          label: Text(product.isAvailable
                              ? 'Agregar al carrito'
                              : 'Sin stock'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return Container(
        color: Colors.brown.shade100,
        child: const Icon(Icons.image, size: 64, color: Colors.brown),
      );
    }
    return Image.network(url, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
              color: Colors.brown.shade100,
              child: const Icon(Icons.broken_image, size: 64),
            ));
  }

  void _toggleFavorite(
      WidgetRef ref, ProductEntity product, bool isFavorite) {
    final controller = ref.read(favoritesProvider.notifier);
    if (isFavorite) {
      controller.removeFavorite(product.id);
    } else {
      controller.addFavorite(product);
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.brown),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
