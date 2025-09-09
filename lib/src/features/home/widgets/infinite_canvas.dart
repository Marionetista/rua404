import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/widgets/blured_button.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../../shared/widgets/flying_cover.dart';

class InfiniteCanvas extends StatefulWidget {
  const InfiniteCanvas({super.key});

  @override
  InfiniteCanvasState createState() => InfiniteCanvasState();
}

final List<Map<String, dynamic>> imagensMock = [
  {
    'url': 'assets/images/doggie.png',
    'largura': 200.0,
    'title': 'Doggie',
    'type': ['Print', 'Sticker'],
    'collab': false,
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'largura': 150.0,
    'title': 'Rua Caxin',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/fakepng.png',
    'largura': 250.0,
    'title': 'RuA Fake PNG',
    'type': ['Sticker'],
    'collab': false,
  },
  {
    'url': 'assets/images/gato.jpg',
    'largura': 180.0,
    'title': 'Gato',
    'type': ['Print'],
    'collab': false,
  },
  {
    'url': 'assets/images/noidRuaDoggie.jpg',
    'largura': 120.0,
    'title': 'Doggie NOID',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/pimp.png',
    'largura': 200.0,
    'title': 'Doggie P.I.M.P',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/pimp.png',
    'largura': 200.0,
    'title': 'Doggie P.I.M.P',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/pimp.png',
    'largura': 200.0,
    'title': 'Doggie P.I.M.P',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/pimp.png',
    'largura': 200.0,
    'title': 'Doggie P.I.M.P',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/pimp.png',
    'largura': 200.0,
    'title': 'Doggie P.I.M.P',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
];

class InfiniteCanvasState extends State<InfiniteCanvas> {
  final double tileSize = 200;
  final int range = 100;

  bool showPopup = false;
  String? selectedImage;

  void openImage(String imagePath) {
    setState(() {
      showPopup = true;
      selectedImage = imagePath;
    });

    // Usar showDialog para criar um popup customizado com animações
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder:
          (BuildContext context) => _ImagePopup(
            imagePath: imagePath,
            onClose: () {
              Navigator.of(context).pop();
              if (mounted) {
                setState(() => showPopup = false);
              }
            },
          ),
    );
  }

  void closePopup() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 0.1,
        maxScale: 5.0,
        child: Wrap(
          spacing: 100.0,
          runSpacing: 100.0,
          children:
              imagensMock.map((imagem) {
                final larguraDaImagem = imagem['largura'] as double? ?? 150.0;
                return GestureDetector(
                  onTap: () => openImage(imagem['url'] as String),
                  child: SizedBox(
                    width: larguraDaImagem,
                    child: AspectRatio(
                      aspectRatio: larguraDaImagem / 100,
                      child: Image.asset(
                        imagem['url'] as String,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Center(child: Text('Erro ao carregar')),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
      if (showPopup)
        AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: closePopup,
            child: Container(color: const Color.fromARGB(243, 0, 0, 0)),
          ),
        ),
    ],
  );
}

class _ImagePopup extends StatefulWidget {
  const _ImagePopup({required this.imagePath, required this.onClose});

  final String imagePath;
  final VoidCallback onClose;

  @override
  State<_ImagePopup> createState() => _ImagePopupState();
}

class _ImagePopupState extends State<_ImagePopup>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background com blur
          GestureDetector(
            onTap: widget.onClose,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
              child: Container(
                color: Colors.black.withValues(alpha: 0.1),
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
                            imgUrl: widget.imagePath,
                            onTap: widget.onClose,
                            width: 250,
                            height: 300,
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
                                          alpha: 0.6,
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
                                                    'Páginas Mock Mangá',
                                                    style: TextStyle(
                                                      color: AppColors.ruaWhite,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Print',
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
                                            'Lorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elit...',
                                            style: TextStyle(
                                              color: AppColors.greyText,
                                              fontSize: 14,
                                              height: 1.4,
                                            ),
                                            maxLines: 3,
                                          ),
                                          const SizedBox(height: 20),
                                          const SizedBox(
                                            width: 130,
                                            child: BlurTextButton(
                                              text: 'Ler mais',
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
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
