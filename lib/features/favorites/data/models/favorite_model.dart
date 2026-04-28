// ============================================================================
//  features/favorites/data/models/favorite_model.dart
// ============================================================================

import '../../domain/entities/favorite_entity.dart';

class FavoriteModel {
  final int? id;
  final int productId;
  final String productName;
  final int addedAt;

  const FavoriteModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.addedAt,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) => FavoriteModel(
        id: map['id'] as int?,
        productId: map['productId'] as int,
        productName: map['productName'] as String,
        addedAt: map['addedAt'] as int,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'productId': productId,
        'productName': productName,
        'addedAt': addedAt,
      };

  FavoriteEntity toEntity() => FavoriteEntity(
        id: id ?? 0,
        productId: productId,
        productName: productName,
        addedAt: DateTime.fromMillisecondsSinceEpoch(addedAt),
      );
}
