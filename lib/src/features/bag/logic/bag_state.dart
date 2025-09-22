import 'package:equatable/equatable.dart';

import 'bag_item.dart';

abstract class BagState extends Equatable {
  const BagState();

  @override
  List<Object> get props => [];
}

class BagInitial extends BagState {}

class BagLoaded extends BagState {
  const BagLoaded({required this.items});

  final List<BagItem> items;

  // Quantidade total de itens no carrinho
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // Subtotal do carrinho
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Verifica se o carrinho está vazio
  bool get isEmpty => items.isEmpty;

  BagLoaded copyWith({List<BagItem>? items}) =>
      BagLoaded(items: items ?? this.items);

  @override
  List<Object> get props => [items];
}
