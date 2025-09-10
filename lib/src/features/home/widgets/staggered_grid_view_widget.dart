import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../shared/widgets/image_popup.dart';

// Pool de imagens para o staggered grid
final List<Map<String, dynamic>> staggeredImagePool = [
  {
    'url': 'assets/images/doggie.png',
    'width': 200.0,
    'height': 150.0,
    'title': 'Doggie',
    'type': ['Print', 'Sticker'],
    'collab': false,
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 150.0,
    'height': 200.0,
    'title': 'Rua Caxin',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/fakepng.png',
    'width': 250.0,
    'height': 180.0,
    'title': 'RuA Fake PNG',
    'type': ['Sticker'],
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
    'type': ['Print', 'Sticker'],
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
    'url': 'assets/images/sacolaVazia.svg',
    'width': 160.0,
    'height': 160.0,
    'title': 'Sacola Vazia',
    'type': ['Sticker'],
    'collab': false,
  },
  {
    'url': 'assets/images/noidRuaDoggie.jpg',
    'width': 140.0,
    'height': 190.0,
    'title': 'Doggie NOID 2',
    'type': ['Print', 'Sticker'],
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
    'type': ['Print', 'Sticker'],
    'collab': false,
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 190.0,
    'height': 170.0,
    'title': 'Rua Caxin 2',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/fakepng.png',
    'width': 160.0,
    'height': 200.0,
    'title': 'RuA Fake PNG 2',
    'type': ['Sticker'],
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
    'type': ['Print', 'Sticker'],
    'collab': false,
  },
  {
    'url': 'assets/images/noidRuaDoggie.jpg',
    'width': 130.0,
    'height': 180.0,
    'title': 'Doggie NOID 3',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 210.0,
    'height': 160.0,
    'title': 'Rua Caxin 3',
    'type': ['Print', 'Sticker'],
    'collab': true,
  },
  {
    'url': 'assets/images/fakepng.png',
    'width': 190.0,
    'height': 240.0,
    'title': 'RuA Fake PNG 3',
    'type': ['Sticker'],
    'collab': false,
  },
];

class StaggeredGridViewWidget extends StatefulWidget {
  const StaggeredGridViewWidget({super.key});

  @override
  State<StaggeredGridViewWidget> createState() =>
      _StaggeredGridViewWidgetState();
}

class _StaggeredGridViewWidgetState extends State<StaggeredGridViewWidget> {
  void _openImagePopup(String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder:
          (BuildContext context) => ImagePopup(
            imagePath: imagePath,
            onClose: () => Navigator.of(context).pop(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: staggeredImagePool.length,
      itemBuilder: (context, index) {
        final imageData = staggeredImagePool[index];
        final aspectRatio = imageData['width'] / imageData['height'];

        return GestureDetector(
          onTap: () => _openImagePopup(imageData['url']),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Image.asset(
                  imageData['url'],
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
      },
    ),
  );
}
