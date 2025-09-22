import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../colors/app_colors.dart';
import '../cubits/image_variation/image_variation_cubit.dart';
import '../cubits/image_variation/image_variation_state.dart';

class ProductVariationCarouselWidget extends StatelessWidget {
  const ProductVariationCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ImageVariationCubit, ImageVariationState>(
        builder: (context, state) {
          if (state is! ImageVariationLoaded) {
            return const SizedBox.shrink();
          }

          final currentImageItem = state.imageItem;
          final selectedVariationIndex = state.selectedVariationIndex;

          if (currentImageItem.variations.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Variações',
                style: TextStyle(
                  color: AppColors.ruaWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentImageItem.variations.length,
                  itemBuilder: (context, index) {
                    final variation = currentImageItem.variations[index];
                    final isSelected = selectedVariationIndex == index;

                    return GestureDetector(
                      onTap:
                          () => context
                              .read<ImageVariationCubit>()
                              .selectVariation(index),
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 0),
                        child: Column(
                          children: [
                            // Imagem da variação
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? AppColors.ruaWhite
                                          : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  variation.url,
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

                            // Tipo do produto
                            Text(
                              variation.getImageTypeText(variation),
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? AppColors.ruaWhite
                                        : AppColors.greyText,
                                fontSize: 10,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
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
        },
      );
}
