import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/image_item_model.dart';
import 'image_variation_state.dart';

class ImageVariationCubit extends Cubit<ImageVariationState> {
  ImageVariationCubit() : super(const ImageVariationInitial());

  void loadImageItem(ImageItem imageItem) {
    emit(ImageVariationLoaded(imageItem, 0));
  }

  void selectVariation(int variationIndex) {
    final currentState = state;
    if (currentState is ImageVariationLoaded) {
      emit(ImageVariationLoaded(currentState.imageItem, variationIndex));
    }
  }

  ImageItem? get currentImageItem {
    final currentState = state;
    if (currentState is ImageVariationLoaded) {
      return currentState.imageItem;
    }
    return null;
  }

  ImageItem? get selectedVariation {
    final currentState = state;
    if (currentState is ImageVariationLoaded) {
      final imageItem = currentState.imageItem;
      final selectedIndex = currentState.selectedVariationIndex;

      if (imageItem.variations.isNotEmpty &&
          selectedIndex < imageItem.variations.length) {
        return imageItem.variations[selectedIndex];
      }
      return imageItem; // Retorna o item principal se não há variações
    }
    return null;
  }
}
