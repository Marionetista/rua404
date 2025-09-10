import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/image_item_model.dart';

// Estados
abstract class ImageVariationState extends Equatable {
  const ImageVariationState();

  @override
  List<Object?> get props => [];
}

class ImageVariationInitial extends ImageVariationState {
  const ImageVariationInitial();
}

class ImageVariationLoaded extends ImageVariationState {
  const ImageVariationLoaded(this.imageItem);

  final ImageItem imageItem;

  @override
  List<Object?> get props => [imageItem];
}

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
