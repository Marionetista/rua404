import 'package:equatable/equatable.dart';

import '../enums/filter_type.dart';

class ImageItem extends Equatable {
  // Factory constructor para criar a partir de Map (compatibilidade com código existente)
  factory ImageItem.fromMap(Map<String, dynamic> map) => ImageItem(
    url: map['url'] as String,
    width: (map['width'] as num).toDouble(),
    height: (map['height'] as num).toDouble(),
    types: List<FilterType>.from(map['types'] as List),
    title: map['title'] as String,
    description: map['description'] as String? ?? 'Descrição não disponível',
    variations:
        map['variations'] != null
            ? List<String>.from(map['variations'] as List)
            : const [],
    isCollab: map['collab'] as bool? ?? false,
    marketable: map['marketable'] as bool? ?? true,
    hasARFilter: map['hasARFilter'] as bool? ?? false,
    size: map['size'] as String? ?? '',
    weight: map['weight'] as String? ?? '',
    materialType: map['materialType'] as String? ?? '',
    printing: map['printing'] as String? ?? '',
    price: (map['price'] as num).toDouble(),
  );

  const ImageItem({
    required this.url,
    required this.width,
    required this.height,
    required this.types,
    required this.title,
    required this.description,
    required this.price,
    this.variations = const [],
    this.isCollab = false,
    this.marketable = true,
    this.hasARFilter = false,
    this.size,
    this.weight,
    this.materialType,
    this.printing,
  });

  final String url;
  final double width;
  final double height;
  final List<FilterType> types;
  final String title;
  final String description;
  final List<String> variations;
  final bool isCollab;
  final bool marketable;
  final bool hasARFilter;
  final String? size;
  final String? weight;
  final String? materialType;
  final String? printing;
  final double price;

  // Método para converter para Map (compatibilidade com código existente)
  Map<String, dynamic> toMap() => {
    'url': url,
    'width': width,
    'height': height,
    'types': types,
    'title': title,
    'description': description,
    'variations': variations,
    'collab': isCollab,
    'marketable': marketable,
    'hasARFilter': hasARFilter,
    'size': size,
    'weight': weight,
    'materialType': materialType,
    'printing': printing,
  };

  // Método para obter a URL atual (considerando variações)
  String get currentUrl => url;

  // Método para verificar se tem variações
  bool get hasVariations => variations.isNotEmpty;

  // Metodo para verificar se o produto está disponível para venda.
  bool get isMarketable => marketable; //&& qtDisponível > 0

  // Método para obter todas as URLs (incluindo a principal e variações)
  List<String> get allUrls => [url, ...variations];

  bool get hasAnyDescription =>
      (size?.isNotEmpty ?? false) ||
      (weight?.isNotEmpty ?? false) ||
      (materialType?.isNotEmpty ?? false) ||
      (printing?.isNotEmpty ?? false) ||
      isCollab;

  String getImageTypeText(ImageItem imageItem) {
    final types = imageItem.types;
    if (types.contains(FilterType.prints) &&
        types.contains(FilterType.stickers)) {
      return 'Print & Sticker';
    } else if (types.contains(FilterType.prints)) {
      return 'Print';
    } else if (types.contains(FilterType.stickers)) {
      return 'Sticker';
    }
    return 'Print';
  }

  // Método para criar uma cópia com URL diferente (para troca de variação)
  ImageItem copyWithUrl(String newUrl) => ImageItem(
    url: newUrl,
    width: width,
    height: height,
    types: types,
    title: title,
    description: description,
    variations: variations,
    isCollab: isCollab,
    marketable: marketable,
    hasARFilter: hasARFilter,
    size: size,
    weight: weight,
    materialType: materialType,
    printing: printing,
    price: price,
  );

  @override
  List<Object?> get props => [
    url,
    width,
    height,
    types,
    title,
    description,
    variations,
    isCollab,
    marketable,
    hasARFilter,
    size,
    weight,
    materialType,
    printing,
    price,
  ];
}
