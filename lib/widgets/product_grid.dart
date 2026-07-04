import 'package:flutter/material.dart';
import '../models/product_item.dart';
import 'product_card.dart';

/// Custom Widget 4 — Grid Produk (wrapper GridView.builder)
class ProductGrid extends StatelessWidget {
  final List<ProductItem> products;
  final int crossAxisCount;
  final void Function(ProductItem)? onTap;

  const ProductGrid({
    super.key,
    required this.products,
    this.crossAxisCount = 2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.76,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => ProductCard(
        product: products[i],
        onTap: onTap != null ? () => onTap!(products[i]) : null,
      ),
    );
  }
}