import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../shared/enums/filter_type.dart';
import '../../../shared/widgets/image_popup.dart';

// Pool de imagens para o staggered grid
final List<Map<String, dynamic>> staggeredImagePool = [
  {
    'url': 'assets/images/doggie.png',
    'width': 200.0,
    'height': 150.0,
    'types': [FilterType.classicos, FilterType.stickers, FilterType.prints],
    'title': 'Doggie Collection',
    'description': 'Uma coleção incrível de designs com cachorros',
  },
  {
    'url': 'assets/images/gato.jpg',
    'width': 180.0,
    'height': 220.0,
    'types': [FilterType.collabs, FilterType.novos],
    'title': 'Gato Collab',
    'description': 'Colaboração especial com artistas locais',
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 160.0,
    'height': 200.0,
    'types': [FilterType.collabs, FilterType.stickers],
    'title': 'Caxin Collab',
    'description': 'Projeto colaborativo exclusivo',
  },
  {
    'url': 'assets/images/pimp.png',
    'width': 220.0,
    'height': 180.0,
    'types': [FilterType.classicos, FilterType.prints],
    'title': 'Pimp Classic',
    'description': 'Design clássico atemporal',
  },
  {
    'url': 'assets/images/festival.jpg',
    'width': 200.0,
    'height': 160.0,
    'types': [FilterType.prints, FilterType.collabs],
    'title': 'Festival Print',
    'description': 'Arte para impressão em alta qualidade',
  },
  {
    'url': 'assets/images/fakepng.png',
    'width': 180.0,
    'height': 240.0,
    'types': [FilterType.stickers, FilterType.novos],
    'title': 'Fake Sticker',
    'description': 'Adesivo exclusivo da coleção',
  },
  {
    'url': 'assets/images/noidRuaDoggie.jpg',
    'width': 190.0,
    'height': 170.0,
    'types': [FilterType.novos, FilterType.classicos],
    'title': 'No ID Rua Doggie',
    'description': 'Novo design da série Rua',
  },
  {
    'url': 'assets/images/doggie.png',
    'width': 210.0,
    'height': 190.0,
    'types': [FilterType.prints, FilterType.stickers],
    'title': 'Doggie Print',
    'description': 'Versão para impressão do Doggie',
  },
  {
    'url': 'assets/images/gato.jpg',
    'width': 170.0,
    'height': 210.0,
    'types': [FilterType.classicos, FilterType.prints],
    'title': 'Gato Classic',
    'description': 'Versão clássica do Gato',
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 200.0,
    'height': 180.0,
    'types': [FilterType.stickers, FilterType.collabs],
    'title': 'Caxin Sticker',
    'description': 'Adesivo da colaboração Caxin',
  },
  {
    'url': 'assets/images/pimp.png',
    'width': 180.0,
    'height': 200.0,
    'types': [FilterType.novos, FilterType.collabs],
    'title': 'Pimp New',
    'description': 'Nova versão do Pimp',
  },
  {
    'url': 'assets/images/festival.jpg',
    'width': 220.0,
    'height': 160.0,
    'types': [FilterType.collabs, FilterType.prints],
    'title': 'Festival Collab',
    'description': 'Colaboração especial do Festival',
  },
  {
    'url': 'assets/images/fakepng.png',
    'width': 190.0,
    'height': 220.0,
    'types': [FilterType.prints, FilterType.stickers],
    'title': 'Fake Print',
    'description': 'Versão para impressão do Fake',
  },
  {
    'url': 'assets/images/noidRuaDoggie.jpg',
    'width': 200.0,
    'height': 180.0,
    'types': [FilterType.classicos, FilterType.novos],
    'title': 'No ID Classic',
    'description': 'Versão clássica do No ID',
  },
  {
    'url': 'assets/images/doggie.png',
    'width': 180.0,
    'height': 200.0,
    'types': [FilterType.stickers, FilterType.classicos],
    'title': 'Doggie Sticker',
    'description': 'Adesivo do Doggie',
  },
  {
    'url': 'assets/images/gato.jpg',
    'width': 210.0,
    'height': 170.0,
    'types': [FilterType.novos, FilterType.prints],
    'title': 'Gato New',
    'description': 'Nova versão do Gato',
  },
  {
    'url': 'assets/images/caxinCollab.png',
    'width': 190.0,
    'height': 190.0,
    'types': [FilterType.prints, FilterType.collabs],
    'title': 'Caxin Print',
    'description': 'Versão para impressão do Caxin',
  },
  {
    'url': 'assets/images/pimp.png',
    'width': 200.0,
    'height': 160.0,
    'types': [FilterType.collabs, FilterType.stickers],
    'title': 'Pimp Collab',
    'description': 'Colaboração especial do Pimp',
  },
  {
    'url': 'assets/images/festival.jpg',
    'width': 180.0,
    'height': 220.0,
    'types': [FilterType.stickers, FilterType.novos],
    'title': 'Festival Sticker',
    'description': 'Adesivo do Festival',
  },
];

class StaggeredGridView extends StatefulWidget {
  const StaggeredGridView({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  final FilterType selectedFilter;
  final Function(FilterType) onFilterChanged;

  @override
  State<StaggeredGridView> createState() => _StaggeredGridViewState();
}

class _StaggeredGridViewState extends State<StaggeredGridView> {
  void _openImagePopup(String imageUrl) => showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => ImagePopup(
          imagePath: imageUrl,
          onClose: () => Navigator.of(context).pop(),
        ),
  );

  List<Map<String, dynamic>> get _filteredImages {
    if (widget.selectedFilter == FilterType.todos) {
      return staggeredImagePool;
    }
    return staggeredImagePool.where((image) {
      final List<FilterType> imageTypes = image['types'] as List<FilterType>;
      return imageTypes.contains(widget.selectedFilter);
    }).toList();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: _filteredImages.length,
      itemBuilder: (context, index) {
        final imageData = _filteredImages[index];
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
