// ============================================================================
//  features/favorites/domain/entities/favorite_entity.dart
// ============================================================================

import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final DateTime addedAt;

  const FavoriteEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [id, productId, productName, addedAt];
}
