// ============================================================================
//  features/favorites/presentation/pages/favorites_page.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/favorite_controller.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favState = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/products'),
        ),
      ),
      body: favState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aún no tienes favoritos',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Toca ♥ en cualquier producto para guardarlo aquí'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (ctx, i) {
              final fav = favorites[i];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF8B4513),
                    child: Icon(Icons.shopping_bag, color: Colors.white),
                  ),
                  title: Text(fav.productName),
                  subtitle: Text(
                      'Agregado: ${fav.addedAt.day}/${fav.addedAt.month}/${fav.addedAt.year}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => ref
                        .read(favoritesProvider.notifier)
                        .removeFavorite(fav.productId),
                  ),
                  onTap: () => context.go('/products/${fav.productId}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
