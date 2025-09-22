import 'package:equatable/equatable.dart';

import '../../../shared/models/image_item_model.dart';

class BagItem extends Equatable {
  const BagItem({
    required this.imageItem,
    required this.selectedVariation,
    required this.quantity,
  });

  final ImageItem imageItem;
  final String selectedVariation; // URL da variação selecionada
  final int quantity;

  // Preço total do item (preço unitário * quantidade)
  double get totalPrice => imageItem.price * quantity;

  // ID único para identificar o item no carrinho (produto + variação)
  String get id => '${imageItem.title}_${selectedVariation.hashCode}';

  BagItem copyWith({
    ImageItem? imageItem,
    String? selectedVariation,
    int? quantity,
  }) => BagItem(
    imageItem: imageItem ?? this.imageItem,
    selectedVariation: selectedVariation ?? this.selectedVariation,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [imageItem, selectedVariation, quantity];
}
