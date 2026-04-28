// ============================================================================
//  features/products/data/models/product_model.dart
//
//  MODELO de datos — Capa Data
//  ────────────────────────────────────────────────────────────────────────
//  DIFERENCIA CLAVE con la Entidad:
//    • ProductModel sabe de JSON, SQLite, APIs.
//    • ProductEntity NO sabe nada de eso.
//    • El modelo tiene métodos de conversión: fromJson, toJson, toEntity.
//
//  FLUJO:
//    API/BD → ProductModel.fromJson() → .toEntity() → ProductEntity
//    ProductEntity → ProductModel.fromEntity() → .toJson() → API/BD
// ============================================================================

import '../../domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final int stock;
  final String artisan;
  final String origin;

  const ProductModel({
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

  // ── Deserialización desde JSON (respuesta de la API) ───────────────────
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      // La API pública usa 'title', nosotros usamos 'name' internamente
      name: json['name'] as String? ?? json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? 'otro',
      imageUrl: json['image'] as String? ?? json['imageUrl'] as String? ?? '',
      stock: json['stock'] as int? ?? 10,
      artisan: json['artisan'] as String? ?? 'Artesano Andino',
      origin: json['origin'] as String? ?? 'Cusco',
    );
  }

  // ── Serialización a JSON (para enviar a la API) ────────────────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'stock': stock,
        'artisan': artisan,
        'origin': origin,
      };

  // ── Deserialización desde SQLite (mapa de BD local) ───────────────────
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      price: map['price'] as double,
      category: map['category'] as String? ?? 'otro',
      imageUrl: map['imageUrl'] as String? ?? '',
      stock: map['stock'] as int? ?? 0,
      artisan: map['artisan'] as String? ?? '',
      origin: map['origin'] as String? ?? '',
    );
  }

  // ── Serialización a mapa SQLite ────────────────────────────────────────
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'stock': stock,
        'artisan': artisan,
        'origin': origin,
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
      };

  // ── CONVERSIÓN AL DOMINIO (lo más importante) ─────────────────────────
  /// Convierte el modelo en una entidad del dominio.
  /// Esta conversión "cruza la frontera" entre Data y Domain.
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      category: _mapCategory(category),
      imageUrl: imageUrl,
      stock: stock,
      artisan: artisan,
      origin: origin,
    );
  }

  /// Construye un modelo desde una entidad del dominio.
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      category: entity.category.name,
      imageUrl: entity.imageUrl,
      stock: entity.stock,
      artisan: entity.artisan,
      origin: entity.origin,
    );
  }

  // ── Mapeo de categorías (string API → enum del dominio) ───────────────
  static ProductCategory _mapCategory(String category) {
    switch (category.toLowerCase()) {
      case "men's clothing":
      case 'textiles':
        return ProductCategory.textiles;
      case 'electronics':
      case 'ceramica':
      case 'cerámica':
        return ProductCategory.ceramica;
      case 'jewelery':
      case 'joyeria':
      case 'joyería':
        return ProductCategory.joyeria;
      case 'madera':
        return ProductCategory.madera;
      case "women's clothing":
      case 'pintura':
        return ProductCategory.pintura;
      default:
        return ProductCategory.otro;
    }
  }
}
