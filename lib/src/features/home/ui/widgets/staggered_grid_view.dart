import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../shared/enums/filter_type.dart';
import '../../../../shared/mocks_mvp/images_mock.dart';
import '../../../../shared/models/image_item_model.dart';
import '../../../../shared/widgets/image_popup.dart';

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
          ? staggeredImagePoolMock
          : staggeredImagePoolMock
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
