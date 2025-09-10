import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/art/art_detail_page.dart';
import '../colors/app_colors.dart';
import '../cubits/image_variation_cubit.dart';
import '../enums/filter_type.dart';
import '../models/image_item_model.dart';
import 'blured_button.dart';
import 'circle_button.dart';
import 'flying_cover.dart';
import 'variation_selection_widget.dart';

class ImagePopup extends StatefulWidget {
  const ImagePopup({required this.imageItem, required this.onClose, super.key});

  final ImageItem imageItem;
  final VoidCallback onClose;

  @override
  State<ImagePopup> createState() => _ImagePopupState();
}

class _ImagePopupState extends State<ImagePopup> with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _contentController;
  late Animation<Offset> _imageAnimation;
  late Animation<double> _contentOpacity;
  late Animation<double> _contentSlide;

  @override
  void initState() {
    super.initState();

    // Controller para animação da imagem
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controller para animação do conteúdo
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animação da imagem: escala e posição
    _imageAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Começa um pouco abaixo
      end: Offset.zero, // Vai para o centro
    ).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOutCubic),
    );

    // Animação de opacidade do conteúdo
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Animação de slide do conteúdo
    _contentSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Iniciar animações
    _imageController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _getImageTypeText(ImageItem imageItem) {
    final types = imageItem.types;
    if (types.contains(FilterType.prints) &&
        types.contains(FilterType.stickers)) {
      return 'Print & Sticker';
    } else if (types.contains(FilterType.prints)) {
      return 'Print';
    } else if (types.contains(FilterType.stickers)) {
      return 'Sticker';
    }
    return 'Print'; // Default
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create:
          (context) => ImageVariationCubit()..loadImageItem(widget.imageItem),
      child: BlocBuilder<ImageVariationCubit, ImageVariationState>(
        builder: (context, state) {
          if (state is! ImageVariationLoaded) {
            return const SizedBox.shrink();
          }

          final currentImageItem = state.imageItem;

          return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: widget.onClose,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),

                // Conteúdo do popup
                Center(
                  child: AnimatedBuilder(
                    animation: _imageController,
                    builder:
                        (context, child) => Transform.translate(
                          offset: Offset(
                            _imageAnimation.value.dx * screenSize.width,
                            _imageAnimation.value.dy * screenSize.height,
                          ),
                          child: Transform.scale(
                            scale: 0.8 + (0.2 * _imageController.value),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Imagem com FlyingCover (zoom e swipe para fechar)
                                FlyingCover(
                                  imgUrl: currentImageItem.url,
                                  onTap: widget.onClose,
                                  width: 250,
                                  height: 300,
                                  imageTypes: currentImageItem.types,
                                ),

                                const SizedBox(height: 30),

                                // Conteúdo com fade e slide
                                AnimatedBuilder(
                                  animation: _contentController,
                                  builder:
                                      (context, child) => Transform.translate(
                                        offset: Offset(0, _contentSlide.value),
                                        child: Opacity(
                                          opacity: _contentOpacity.value,
                                          child: Container(
                                            width: screenSize.width * 0.9,
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                alpha: 0.9,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          currentImageItem
                                                              .title,
                                                          style: TextStyle(
                                                            color:
                                                                AppColors
                                                                    .ruaWhite,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          _getImageTypeText(
                                                            currentImageItem,
                                                          ),
                                                          style: TextStyle(
                                                            color:
                                                                AppColors
                                                                    .greyText,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Row(
                                                      children: [
                                                        CircleButton(
                                                          icon:
                                                              CircleButtonIcon
                                                                  .aircon,
                                                        ),
                                                        SizedBox(width: 10),
                                                        CircleButton(
                                                          icon:
                                                              CircleButtonIcon
                                                                  .addBag,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),

                                                // Seção de variações
                                                BlocProvider.value(
                                                  value:
                                                      context
                                                          .read<
                                                            ImageVariationCubit
                                                          >(),
                                                  child:
                                                      const VariationSelectionWidget(),
                                                ),
                                                const SizedBox(height: 20),

                                                Text(
                                                  'Sobre a peça',
                                                  style: TextStyle(
                                                    color: AppColors.ruaWhite,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  currentImageItem.description,
                                                  style: TextStyle(
                                                    color: AppColors.greyText,
                                                    fontSize: 14,
                                                    height: 1.4,
                                                  ),
                                                  maxLines: 3,
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 130,
                                                      child: BlurTextButton(
                                                        text: 'Ler mais',
                                                        onTap: () {
                                                          final cubit =
                                                              context
                                                                  .read<
                                                                    ImageVariationCubit
                                                                  >();
                                                          Navigator.of(
                                                            context,
                                                          ).push(
                                                            PageRouteBuilder(
                                                              opaque: false,
                                                              transitionDuration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        200,
                                                                  ),
                                                              pageBuilder:
                                                                  (
                                                                    context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                  ) => BlocProvider.value(
                                                                    value:
                                                                        cubit,
                                                                    child: ArtDetailPage(
                                                                      imageItem:
                                                                          currentImageItem,
                                                                    ),
                                                                  ),
                                                              transitionsBuilder:
                                                                  (
                                                                    context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child,
                                                                  ) => FadeTransition(
                                                                    opacity:
                                                                        animation,
                                                                    child:
                                                                        child,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
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
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
