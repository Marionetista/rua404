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

// Pool de imagens únicas para a galeria infinita
final List<Map<String, dynamic>> imagePool = [
  {
    'url': 'assets/images/doggie.png',
    'width': 200.0,
    'height': 150.0,
    'title': 'Doggie',
    'type': ['Print', 'Sticker', 'Classico'],
    'collab': false,
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 150.0,
    'height': 200.0,
    'title': 'Rua Caxin',
    'type': ['Print', 'Sticker', 'Collab'],
    'collab': true,
  },
  {
    'url': 'assets/images/fakepng.png',
    'width': 250.0,
    'height': 180.0,
    'title': 'RuA Fake PNG',
    'type': ['Sticker', 'Classico'],
    'collab': false,
  },
  {
    'url': 'assets/images/gato.jpg',
    'width': 180.0,
    'height': 220.0,
    'title': 'Gato',
    'type': ['Print'],
    'collab': false,
  },
  {
    'url': 'assets/images/noidRuaDoggie.jpg',
    'width': 120.0,
    'height': 160.0,
    'title': 'Doggie NOID',
    'type': ['Print', 'Sticker', 'Collab'],
    'collab': true,
  },
  {
    'url': 'assets/images/pimp.png',
    'width': 200.0,
    'height': 250.0,
    'title': 'Doggie P.I.M.P',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/festival.jpg',
    'width': 300.0,
    'height': 200.0,
    'title': 'Festival',
    'type': ['Print'],
    'collab': false,
  },
  {
    'url': 'assets/images/noidRuaDoggie.jpg',
    'width': 140.0,
    'height': 190.0,
    'title': 'Doggie NOID 2',
    'type': ['Print', 'Sticker', 'Collab'],
    'collab': true,
  },
  {
    'url': 'assets/images/gato.jpg',
    'width': 220.0,
    'height': 160.0,
    'title': 'Gato 2',
    'type': ['Print'],
    'collab': false,
  },
  {
    'url': 'assets/images/doggie.png',
    'width': 180.0,
    'height': 140.0,
    'title': 'Doggie 2',
    'type': ['Print', 'Sticker', 'Classico'],
    'collab': false,
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 190.0,
    'height': 170.0,
    'title': 'Rua Caxin 2',
    'type': ['Print', 'Sticker', 'Collab'],
    'collab': true,
  },
  {
    'url': 'assets/images/fakepng.png',
    'width': 160.0,
    'height': 200.0,
    'title': 'RuA Fake PNG 2',
    'type': ['Sticker', 'Classico'],
    'collab': false,
  },
  {
    'url': 'assets/images/pimp.png',
    'width': 240.0,
    'height': 180.0,
    'title': 'Doggie P.I.M.P 2',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/festival.jpg',
    'width': 280.0,
    'height': 220.0,
    'title': 'Festival 2',
    'type': ['Print'],
    'collab': false,
  },
  {
    'url': 'assets/images/gato.jpg',
    'width': 200.0,
    'height': 180.0,
    'title': 'Gato 3',
    'type': ['Print'],
    'collab': false,
  },
  {
    'url': 'assets/images/doggie.png',
    'width': 170.0,
    'height': 130.0,
    'title': 'Doggie 3',
    'type': ['Print', 'Sticker', 'Classico'],
    'collab': false,
  },
  {
    'url': 'assets/images/noidRuaDoggie.jpg',
    'width': 130.0,
    'height': 180.0,
    'title': 'Doggie NOID 3',
    'type': ['Print', 'Sticker', 'Collab'],
    'collab': true,
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 210.0,
    'height': 160.0,
    'title': 'Rua Caxin 3',
    'type': ['Print', 'Sticker', 'Collab'],
    'collab': true,
  },
  {
    'url': 'assets/images/fakepng.png',
    'width': 190.0,
    'height': 240.0,
    'title': 'RuA Fake PNG 3',
    'type': ['Sticker', 'Classico'],
    'collab': false,
  },
];

class InfiniteCanvasState extends State<InfiniteCanvas> {
  // Configurações da galeria
  final double gridSize = 300.0; // Tamanho base da grade
  final double minSpacing = 20.0; // Espaçamento mínimo entre imagens

  // Controle de viewport
  late TransformationController _transformationController;
  Offset _currentOffset = Offset.zero;
  double _currentScale = 1.0;

  // Pool de imagens e controle de posicionamento
  final Set<String> _usedImages = <String>{};
  final Map<String, Offset> _imagePositions = <String, Offset>{};
  final List<Widget> _visibleImages = <Widget>[];

  // Cache e throttling para performance
  final Map<String, Widget> _imageWidgetCache = <String, Widget>{};
  DateTime _lastUpdate = DateTime.now();
  static const Duration _updateThrottle = Duration(milliseconds: 100);
  Rect? _lastViewport;

  // Estado do popup
  bool showPopup = false;
  String? selectedImage;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _transformationController.addListener(_onTransformationChanged);

    // Inicializar com algumas imagens visíveis
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateVisibleImages();
    });
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final Matrix4 matrix = _transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();
    final Offset offset = Offset(
      matrix.getTranslation().x,
      matrix.getTranslation().y,
    );

    setState(() {
      _currentScale = scale;
      _currentOffset = offset;
    });

    // Throttling para evitar atualizações excessivas
    final now = DateTime.now();
    if (now.difference(_lastUpdate) > _updateThrottle) {
      _lastUpdate = now;
      _updateVisibleImages();
    }
  }

  void _updateVisibleImages() {
    if (!mounted) return;

    final screenSize = MediaQuery.of(context).size;
    final viewportWidth = screenSize.width / _currentScale;
    final viewportHeight = screenSize.height / _currentScale;

    // Calcular área visível
    final double left = -_currentOffset.dx / _currentScale;
    final double top = -_currentOffset.dy / _currentScale;
    final double right = left + viewportWidth;
    final double bottom = top + viewportHeight;

    // Expandir área para incluir imagens próximas
    const double margin = 500.0;
    final double expandedLeft = left - margin;
    final double expandedTop = top - margin;
    final double expandedRight = right + margin;
    final double expandedBottom = bottom + margin;

    // Criar retângulo do viewport atual
    final currentViewport = Rect.fromLTRB(
      expandedLeft,
      expandedTop,
      expandedRight,
      expandedBottom,
    );

    // Verificar se o viewport mudou significativamente
    if (_lastViewport != null &&
        _lastViewport!.overlaps(currentViewport) &&
        _lastViewport!.contains(currentViewport.center)) {
      return; // Não atualizar se ainda estamos na mesma área
    }

    _lastViewport = currentViewport;

    // Gerar posições para imagens na área visível
    _generateImagesInArea(
      expandedLeft,
      expandedTop,
      expandedRight,
      expandedBottom,
    );
  }

  void _generateImagesInArea(
    double left,
    double top,
    double right,
    double bottom,
  ) {
    final List<Widget> newVisibleImages = <Widget>[];

    // Calcular quantas imagens cabem na área
    final double areaWidth = right - left;
    final double areaHeight = bottom - top;
    final int cols = (areaWidth / gridSize).ceil();
    final int rows = (areaHeight / gridSize).ceil();

    // Gerar posições na grade
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final double x = left + (col * gridSize);
        final double y = top + (row * gridSize);

        // Verificar se já existe uma imagem nesta posição
        final String positionKey =
            '${x.toStringAsFixed(0)},${y.toStringAsFixed(0)}';

        // Se já existe um widget cacheado para esta posição, usar ele
        if (_imageWidgetCache.containsKey(positionKey)) {
          newVisibleImages.add(_imageWidgetCache[positionKey]!);
          continue;
        }

        // Se já existe uma posição mas não tem widget cacheado, pular
        if (_imagePositions.containsKey(positionKey)) continue;

        // Encontrar uma imagem não usada
        final availableImages =
            imagePool
                .where((img) => !_usedImages.contains(img['url']))
                .toList();

        Map<String, dynamic> selectedImageData;

        // Se todas as imagens foram usadas, resetar o pool
        if (availableImages.isEmpty) {
          _usedImages.clear();
          _imagePositions.clear();
          _imageWidgetCache.clear(); // Limpar cache também
          selectedImageData = imagePool.first;
        } else {
          // Selecionar imagem aleatória
          final random =
              DateTime.now().millisecondsSinceEpoch % availableImages.length;
          selectedImageData = availableImages[random];
        }

        // Marcar como usada e adicionar posição
        _usedImages.add(selectedImageData['url']);
        _imagePositions[positionKey] = Offset(x, y);

        // Criar widget da imagem
        final imageWidget = Positioned(
          left: x,
          top: y,
          child: GestureDetector(
            onTap: () => openImage(selectedImageData['url']),
            child: Container(
              width: selectedImageData['width'],
              height: selectedImageData['height'],
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  selectedImageData['url'],
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
          ),
        );

        // Cachear o widget para reutilização
        _imageWidgetCache[positionKey] = imageWidget;
        newVisibleImages.add(imageWidget);
      }
    }

    setState(() {
      _visibleImages.clear();
      _visibleImages.addAll(newVisibleImages);
    });
  }

  void openImage(String imagePath) {
    setState(() {
      showPopup = true;
      selectedImage = imagePath;
    });

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
        transformationController: _transformationController,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 0.1,
        maxScale: 3.0,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(children: _visibleImages),
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
