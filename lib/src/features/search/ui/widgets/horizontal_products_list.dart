import 'package:flutter/material.dart';

import '../../../../shared/colors/app_colors.dart';
import '../../../../shared/models/image_item_model.dart';

class HorizontalProductsList extends StatelessWidget {
  const HorizontalProductsList({
    required this.products,
    required this.onProductTap,
    this.title = 'Produtos',
    this.maxItems = 5,
    super.key,
  });

  final List<ImageItem> products;
  final Function(ImageItem) onProductTap;
  final String title;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.ruaWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.take(maxItems).length,
            itemBuilder: (context, index) {
              final image = products[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => onProductTap(image),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            image.url,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        image.title,
                        style: TextStyle(
                          color: AppColors.ruaWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
