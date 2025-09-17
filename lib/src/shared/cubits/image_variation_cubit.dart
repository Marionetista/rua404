import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/image_item_model.dart';
import 'image_variation_state.dart';

// Cubit
class ImageVariationCubit extends Cubit<ImageVariationState> {
  ImageVariationCubit() : super(const ImageVariationInitial());

  void loadImageItem(ImageItem imageItem) {
    emit(ImageVariationLoaded(imageItem));
  }

  void changeVariation(String newUrl) {
    final currentState = state;
    if (currentState is ImageVariationLoaded) {
      final newImageItem = currentState.imageItem.copyWithUrl(newUrl);
      emit(ImageVariationLoaded(newImageItem));
    }
  }

  ImageItem? get currentImageItem {
    final currentState = state;
    if (currentState is ImageVariationLoaded) {
      return currentState.imageItem;
    }
    return null;
  }
}
