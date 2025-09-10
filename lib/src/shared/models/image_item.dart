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
    description: map['description'] as String,
    variations:
        map['variations'] != null
            ? List<String>.from(map['variations'] as List)
            : const [],
    isCollab: map['collab'] as bool? ?? false,
  );

  const ImageItem({
    required this.url,
    required this.width,
    required this.height,
    required this.types,
    required this.title,
    required this.description,
    this.variations = const [],
    this.isCollab = false,
  });

  final String url;
  final double width;
  final double height;
  final List<FilterType> types;
  final String title;
  final String description;
  final List<String> variations;
  final bool isCollab;

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
  };

  // Método para obter a URL atual (considerando variações)
  String get currentUrl => url;

  // Método para verificar se tem variações
  bool get hasVariations => variations.isNotEmpty;

  // Método para obter todas as URLs (incluindo a principal e variações)
  List<String> get allUrls => [url, ...variations];

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
  ];
}
