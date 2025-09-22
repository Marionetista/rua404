import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/colors/app_colors.dart';
import '../../../../shared/cubits/image_variation/image_variation_cubit.dart';
import '../../../../utils/app_utils.dart';
import '../../../art/ui/art_detail_page.dart';
import '../../logic/bag_cubit.dart';
import '../../logic/bag_item.dart';

class BagCardWidget extends StatefulWidget {
  const BagCardWidget({required this.bagItem, super.key});

  final BagItem bagItem;

  @override
  State<BagCardWidget> createState() => _BagCardWidgetState();
}

class _BagCardWidgetState extends State<BagCardWidget> {
  void _incrementCounter() {
    context.read<BagCubit>().updateQuantity(
      widget.bagItem.id,
      widget.bagItem.quantity + 1,
    );
  }

  void _decrementCounter() {
    context.read<BagCubit>().updateQuantity(
      widget.bagItem.id,
      widget.bagItem.quantity - 1,
    );
  }

  void _navigateToArtDetail() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder:
            (context, animation, secondaryAnimation) => BlocProvider(
              create:
                  (context) =>
                      ImageVariationCubit()
                        ..loadImageItem(widget.bagItem.imageItem),
              child: ArtDetailPage(imageItem: widget.bagItem.imageItem),
            ),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _navigateToArtDetail,
    child: Container(
      width: 361,
      height: 109,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          SizedBox(
            height: 109,
            width: 109,
            child: Image.asset(
              widget.bagItem.selectedVariation,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    top: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bagItem.imageItem.title,
                        style: TextStyle(
                          color: AppColors.ruaWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.bagItem.imageItem.getImageTypeText(
                          widget.bagItem.imageItem,
                        ),
                        style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppUtils.formatCurrency(widget.bagItem.imageItem.price),
                        style: TextStyle(
                          color: AppColors.ruaWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 48,
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppColors.halfWhite,
                          borderRadius: BorderRadius.circular(48),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: _decrementCounter,
                              child: Image.asset(
                                widget.bagItem.quantity == 1
                                    ? 'assets/icons/trash.png'
                                    : 'assets/icons/remove.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Text(
                                '${widget.bagItem.quantity}',
                                style: TextStyle(
                                  color: AppColors.ruaWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _incrementCounter,
                              child: Image.asset(
                                'assets/icons/add.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
