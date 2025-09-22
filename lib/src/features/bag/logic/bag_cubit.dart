import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/models/image_item_model.dart';
import 'bag_item.dart';
import 'bag_state.dart';

class BagCubit extends Cubit<BagState> {
  BagCubit() : super(BagInitial());

  void initialize() {
    emit(const BagLoaded(items: []));
  }

  void addItem(ImageItem imageItem, String selectedVariation) {
    if (state is! BagLoaded) return;

    final currentState = state as BagLoaded;
    final items = List<BagItem>.from(currentState.items);

    final existingItemIndex = items.indexWhere(
      (item) =>
          item.id ==
          BagItem(
            imageItem: imageItem,
            selectedVariation: selectedVariation,
            quantity: 1,
          ).id,
    );

    if (existingItemIndex >= 0) {
      // Se já existe, incrementa a quantidade
      final existingItem = items[existingItemIndex];
      items[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Se não existe, adiciona novo item
      items.add(
        BagItem(
          imageItem: imageItem,
          selectedVariation: selectedVariation,
          quantity: 1,
        ),
      );
    }

    emit(currentState.copyWith(items: items));
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (state is! BagLoaded) return;

    final currentState = state as BagLoaded;
    final items = List<BagItem>.from(currentState.items);

    final itemIndex = items.indexWhere((item) => item.id == itemId);
    if (itemIndex >= 0) {
      if (newQuantity <= 0) {
        // Remove o item se a quantidade for 0 ou menor
        items.removeAt(itemIndex);
      } else {
        // Atualiza a quantidade
        items[itemIndex] = items[itemIndex].copyWith(quantity: newQuantity);
      }
    }

    emit(currentState.copyWith(items: items));
  }

  void removeItem(String itemId) {
    if (state is! BagLoaded) return;

    final currentState = state as BagLoaded;
    final items = List<BagItem>.from(currentState.items);

    items.removeWhere((item) => item.id == itemId);

    emit(currentState.copyWith(items: items));
  }

  void clear() {
    if (state is! BagLoaded) return;

    final currentState = state as BagLoaded;
    emit(currentState.copyWith(items: []));
  }
}
