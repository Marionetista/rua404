import 'dart:ui';
import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../enums/filter_type.dart';
import '../models/image_item.dart';
import 'blured_button.dart';
import 'circle_button.dart';
import 'flying_cover.dart';

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

  // Variável para controlar a imagem atual selecionada
  late ImageItem _currentImageItem;

  @override
  void initState() {
    super.initState();

    // Inicializar com a imagem padrão
    _currentImageItem = widget.imageItem;

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

  String _getImageTypeText() {
    final types = _currentImageItem.types;
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

  Widget _buildVariationsSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 6),
      SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _currentImageItem.variations.length,
          itemBuilder: (context, index) {
            final variation = _currentImageItem.variations[index];
            final isSelected = variation == _currentImageItem.url;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentImageItem = _currentImageItem.copyWithUrl(variation);
                });
              },
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 12),
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
                              color: AppColors.ruaWhite.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                          : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    variation,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
                            imgUrl: _currentImageItem.url,
                            onTap: widget.onClose,
                            width: 250,
                            height: 300,
                            imageTypes: _currentImageItem.types,
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
                                        borderRadius: BorderRadius.circular(20),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _currentImageItem.title,
                                                    style: TextStyle(
                                                      color: AppColors.ruaWhite,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _getImageTypeText(),
                                                    style: TextStyle(
                                                      color: AppColors.greyText,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  CircleButton(
                                                    icon:
                                                        CircleButtonIcon.aircon,
                                                  ),
                                                  SizedBox(width: 10),
                                                  CircleButton(
                                                    icon:
                                                        CircleButtonIcon.addBag,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),

                                          // Seção de variações
                                          if (_currentImageItem
                                              .hasVariations) ...[
                                            _buildVariationsSection(),
                                            const SizedBox(height: 20),
                                          ],

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
                                            _currentImageItem.description,
                                            style: TextStyle(
                                              color: AppColors.greyText,
                                              fontSize: 14,
                                              height: 1.4,
                                            ),
                                            maxLines: 3,
                                          ),
                                          const SizedBox(height: 20),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 130,
                                                child: BlurTextButton(
                                                  text: 'Ler mais',
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
  }
}
