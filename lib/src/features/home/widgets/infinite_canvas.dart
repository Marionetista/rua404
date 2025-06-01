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
  {'url': 'assets/images/doggie.png', 'largura': 200.0},
  {'url': 'assets/images/caxinCollab.png', 'largura': 150.0},
  {'url': 'assets/images/fakepng.png', 'largura': 250.0},
  {'url': 'assets/images/gato.jpg', 'largura': 180.0},
  {'url': 'assets/images/noidRuaDoggie.jpg', 'largura': 120.0},
  {'url': 'assets/images/pimp.png', 'largura': 200.0},
  {'url': 'assets/images/pimp.png', 'largura': 160.0},
  {'url': 'assets/images/pimp.png', 'largura': 280.0},
  {'url': 'assets/images/pimp.png', 'largura': 190.0},
  {'url': 'assets/images/pimp.png', 'largura': 140.0},
];

class InfiniteCanvasState extends State<InfiniteCanvas> {
  final double tileSize = 200;
  final int range = 100;

  bool showPopup = false;
  String? selectedImage;
  PersistentBottomSheetController? _sheetController;

  void openImage(String imagePath) {
    setState(() {
      showPopup = true;
      selectedImage = imagePath;
    });

    _sheetController = Scaffold.of(context).showBottomSheet(
      backgroundColor: Colors.transparent,
      (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedImage != null)
            Center(
              child: FlyingCover(imgUrl: selectedImage, onTap: closePopup),
            ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Páginas Mock Mangá',
                          style: TextStyle(
                            color: AppColors.ruaWhite,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Print',
                          style: TextStyle(
                            color: AppColors.ruaWhite,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        CircleButton(icon: CircleButtonIcon.aircon),
                        SizedBox(width: 10),
                        CircleButton(icon: CircleButtonIcon.addBag),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Sobre a peça'),
                const SizedBox(height: 8),
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elitLorem ipsum dolor sit amet, consectetur adipiscing elit...',
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  width: 130,
                  child: BlurTextButton(text: 'Ler mais'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );

    _sheetController!.closed.then((_) {
      if (mounted) {
        setState(() => showPopup = false);
      }
    });
  }

  void closePopup() => _sheetController?.close();

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
