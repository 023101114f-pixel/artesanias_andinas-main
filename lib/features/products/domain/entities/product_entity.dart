// ============================================================================
//  features/products/domain/entities/product_entity.dart
//
//  ENTIDAD del dominio: ProductEntity
//  ────────────────────────────────────────────────────────────────────────
//  REGLAS:
//  ✔ Solo Dart puro. CERO imports de Flutter, Firebase, Dio, sqflite.
//  ✔ Contiene reglas de negocio (métodos de validación/lógica).
//  ✔ Usa Equatable para comparación estructural (no referencial).
//  ✔ No sabe nada de cómo se guarda o se obtiene.
// ============================================================================

import 'package:equatable/equatable.dart';

/// Categorías de artesanías andinas
enum ProductCategory {
  textiles('Textiles'),
  ceramica('Cerámica'),
  joyeria('Joyería'),
  madera('Madera Tallada'),
  pintura('Pintura'),
  otro('Otro');

  final String label;
  const ProductCategory(this.label);
}

/// Entidad principal del negocio: un producto artesanal andino
class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;
  final String imageUrl;
  final int stock;
  final String artisan;    // Nombre del artesano
  final String origin;     // Ciudad/comunidad de origen

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.stock,
    required this.artisan,
    required this.origin,
  });

  // ── REGLAS DE NEGOCIO ────────────────────────────────────────────────────

  /// Un producto está disponible si tiene stock mayor a cero
  bool get isAvailable => stock > 0;

  /// Un producto es "premium" si su precio supera los S/. 200
  bool get isPremium => price > 200.0;

  /// Retorna el precio formateado en soles peruanos
  String get formattedPrice => 'S/. ${price.toStringAsFixed(2)}';

  /// Determina el nivel de stock
  String get stockStatus {
    if (stock == 0) return 'Sin stock';
    if (stock <= 5) return 'Últimas unidades ($stock)';
    return 'Disponible ($stock)';
  }

  // ── EQUATABLE ────────────────────────────────────────────────────────────
  @override
  List<Object?> get props => [
        id, name, description, price,
        category, imageUrl, stock, artisan, origin,
      ];

  // ── COPY WITH (inmutabilidad) ─────────────────────────────────────────────
  ProductEntity copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    ProductCategory? category,
    String? imageUrl,
    int? stock,
    String? artisan,
    String? origin,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
      artisan: artisan ?? this.artisan,
      origin: origin ?? this.origin,
    );
  }

  @override
  String toString() =>
      'ProductEntity(id: $id, name: $name, price: $formattedPrice, '
      'category: ${category.label}, artisan: $artisan)';
}
