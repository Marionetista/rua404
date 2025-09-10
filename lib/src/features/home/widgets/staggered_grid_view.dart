import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../shared/enums/filter_type.dart';
import '../../../shared/models/image_item.dart';
import '../../../shared/widgets/image_popup.dart';

// Pool de imagens para o staggered grid
final List<ImageItem> staggeredImagePool = [
  const ImageItem(
    url: 'assets/images/doggie.png',
    width: 200.0,
    height: 150.0,
    types: [FilterType.classicos, FilterType.stickers, FilterType.prints],
    title: 'Doggie Collection',
    description: 'Uma coleção incrível de designs com cachorros',
    variations: ['assets/images/doggie.png', 'assets/images/doggieRosa.png'],
  ),
  const ImageItem(
    url: 'assets/images/gato.jpg',
    width: 180.0,
    height: 220.0,
    types: [FilterType.collabs, FilterType.novos],
    title: 'Gato Collab',
    description: 'Colaboração especial com artistas locais',
    isCollab: true,
  ),
  const ImageItem(
    url: 'assets/images/caxinCollab.png',
    width: 160.0,
    height: 200.0,
    types: [FilterType.collabs, FilterType.stickers],
    title: 'Caxin Collab',
    description: 'Projeto colaborativo exclusivo',
    isCollab: true,
  ),
  const ImageItem(
    url: 'assets/images/pimp.png',
    width: 220.0,
    height: 180.0,
    types: [FilterType.classicos, FilterType.prints],
    title: 'Pimp Classic',
    description: 'Design clássico atemporal',
    variations: ['assets/images/pimp.png'],
  ),
  const ImageItem(
    url: 'assets/images/festival.jpg',
    width: 200.0,
    height: 160.0,
    types: [FilterType.prints, FilterType.collabs],
    title: 'Festival Print',
    description: 'Arte para impressão em alta qualidade',
    isCollab: true,
  ),
  const ImageItem(
    url: 'assets/images/fakepng.png',
    width: 180.0,
    height: 240.0,
    types: [FilterType.stickers, FilterType.novos],
    title: 'Fake Sticker',
    description: 'Adesivo exclusivo da coleção',
  ),
  const ImageItem(
    url: 'assets/images/noidRuaDoggie.jpg',
    width: 190.0,
    height: 170.0,
    types: [FilterType.novos, FilterType.classicos],
    title: 'No ID Rua Doggie',
    description: 'Novo design da série Rua',
  ),
  const ImageItem(
    url: 'assets/images/doggie.png',
    width: 210.0,
    height: 190.0,
    types: [FilterType.prints, FilterType.stickers],
    title: 'Doggie Print',
    description: 'Versão para impressão do Doggie',
  ),
  const ImageItem(
    url: 'assets/images/gato.jpg',
    width: 170.0,
    height: 210.0,
    types: [FilterType.classicos, FilterType.prints],
    title: 'Gato Classic',
    description: 'Versão clássica do Gato',
  ),
  const ImageItem(
    url: 'assets/images/caxinCollab.png',
    width: 200.0,
    height: 180.0,
    types: [FilterType.stickers, FilterType.collabs],
    title: 'Caxin Sticker',
    description: 'Adesivo da colaboração Caxin',
    isCollab: true,
  ),
  const ImageItem(
    url: 'assets/images/pimp.png',
    width: 180.0,
    height: 200.0,
    types: [FilterType.novos, FilterType.collabs],
    title: 'Pimp New',
    description: 'Nova versão do Pimp',
    isCollab: true,
  ),
  const ImageItem(
    url: 'assets/images/festival.jpg',
    width: 190.0,
    height: 170.0,
    types: [FilterType.stickers, FilterType.novos],
    title: 'Festival Sticker',
    description: 'Adesivo do Festival',
  ),
  const ImageItem(
    url: 'assets/images/fakepng.png',
    width: 200.0,
    height: 160.0,
    types: [FilterType.prints, FilterType.classicos],
    title: 'Fake Print',
    description: 'Versão para impressão do Fake',
  ),
  const ImageItem(
    url: 'assets/images/noidRuaDoggie.jpg',
    width: 180.0,
    height: 220.0,
    types: [FilterType.collabs, FilterType.stickers],
    title: 'No ID Collab',
    description: 'Colaboração No ID',
    isCollab: true,
  ),
  const ImageItem(
    url: 'assets/images/doggie.png',
    width: 160.0,
    height: 200.0,
    types: [FilterType.novos, FilterType.prints],
    title: 'Doggie New',
    description: 'Nova versão do Doggie',
  ),
  const ImageItem(
    url: 'assets/images/gato.jpg',
    width: 210.0,
    height: 180.0,
    types: [FilterType.stickers, FilterType.collabs],
    title: 'Gato Sticker',
    description: 'Adesivo do Gato',
    isCollab: true,
  ),
  const ImageItem(
    url: 'assets/images/caxinCollab.png',
    width: 170.0,
    height: 210.0,
    types: [FilterType.prints, FilterType.novos],
    title: 'Caxin Print',
    description: 'Versão para impressão do Caxin',
  ),
  const ImageItem(
    url: 'assets/images/pimp.png',
    width: 200.0,
    height: 160.0,
    types: [FilterType.stickers, FilterType.classicos],
    title: 'Pimp Sticker',
    description: 'Adesivo do Pimp',
  ),
  const ImageItem(
    url: 'assets/images/festival.jpg',
    width: 180.0,
    height: 240.0,
    types: [FilterType.novos, FilterType.prints],
    title: 'Festival New',
    description: 'Nova versão do Festival',
  ),
  const ImageItem(
    url: 'assets/images/fakepng.png',
    width: 190.0,
    height: 170.0,
    types: [FilterType.collabs, FilterType.stickers],
    title: 'Fake Collab',
    description: 'Colaboração Fake',
    isCollab: true,
  ),
];

class StaggeredGridView extends StatefulWidget {
  const StaggeredGridView({required this.selectedFilter, super.key});

  final FilterType selectedFilter;

  @override
  State<StaggeredGridView> createState() => _StaggeredGridViewState();
}

class _StaggeredGridViewState extends State<StaggeredGridView> {
  void _openImagePopup(ImageItem imageItem) => showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => ImagePopup(
          imageItem: imageItem,
          onClose: () => Navigator.of(context).pop(),
        ),
  );

  List<ImageItem> get _filteredImages =>
      widget.selectedFilter == FilterType.todos
          ? staggeredImagePool
          : staggeredImagePool
              .where((image) => image.types.contains(widget.selectedFilter))
              .toList();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: _filteredImages.length,
      itemBuilder: (context, index) {
        final imageItem = _filteredImages[index];
        final aspectRatio = imageItem.width / imageItem.height;

        return GestureDetector(
          onTap: () => _openImagePopup(imageItem),
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
                  imageItem.url,
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
