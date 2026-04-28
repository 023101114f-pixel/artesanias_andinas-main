// ============================================================================
//  features/products/presentation/widgets/category_filter_bar.dart
// ============================================================================

import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';

class CategoryFilterBar extends StatefulWidget {
  const CategoryFilterBar({super.key});

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  ProductCategory? _selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          _buildChip(null, 'Todos'),
          ...ProductCategory.values.map((c) => _buildChip(c, c.label)),
        ],
      ),
    );
  }

  Widget _buildChip(ProductCategory? category, String label) {
    final isSelected = _selected == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selected = category),
        selectedColor: const Color(0xFF8B4513).withOpacity(0.2),
        checkmarkColor: const Color(0xFF8B4513),
      ),
    );
  }
}
