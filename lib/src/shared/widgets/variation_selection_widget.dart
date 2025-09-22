import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../colors/app_colors.dart';
import '../cubits/image_variation/image_variation.dart';

class VariationSelectionWidget extends StatelessWidget {
  const VariationSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ImageVariationCubit, ImageVariationState>(
        builder: (context, state) {
          if (state is! ImageVariationLoaded) {
            return const SizedBox.shrink();
          }

          final currentImageItem = state.imageItem;

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
              const SizedBox(height: 10),

              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentImageItem.variations.length,
                  itemBuilder: (context, index) {
                    final variation = currentImageItem.variations[index];
                    final isSelected = state.selectedVariationIndex == index;

                    return GestureDetector(
                      onTap:
                          () => context
                              .read<ImageVariationCubit>()
                              .selectVariation(index),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(left: 6, right: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppColors.ruaWhite
                                        : Colors.grey.withValues(alpha: 0.3),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: AppColors.ruaWhite.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                      : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.asset(
                                variation.url,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

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
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
}
