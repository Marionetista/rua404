import 'package:equatable/equatable.dart';

import '../models/image_item_model.dart';

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
