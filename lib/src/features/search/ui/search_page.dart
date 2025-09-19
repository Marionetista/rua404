import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/cubits/image_variation/image_variation_cubit.dart';
import '../../../shared/models/image_item_model.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../art/ui/art_detail_page.dart';
import '../../home/ui/widgets/staggered_grid_view_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<ImageItem> _allImages = [];
  List<ImageItem> _filteredImages = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
    // Foco automático no input quando a página abrir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _loadImages() {
    // Carrega todas as imagens do staggeredImagePool
    _allImages =
        staggeredImagePool.map((map) => ImageItem.fromMap(map)).toList();
    _filteredImages = List.from(_allImages);
  }

  void _performSearch(String query) {
    final newIsSearching = query.isNotEmpty;

    setState(() {
      _isSearching = newIsSearching;

      if (query.isEmpty) {
        _filteredImages = List.from(_allImages);
      } else {
        _filteredImages =
            _allImages.where((image) {
              // Busca por nome da obra
              final nameMatch = image.title.toLowerCase().contains(
                query.toLowerCase(),
              );

              // Busca por tipo
              final typeMatch = image.types.any(
                (type) =>
                    type.label.toLowerCase().contains(query.toLowerCase()),
              );

              return nameMatch || typeMatch;
            }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _performSearch('');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Text(
        'Rua 404',
        style: TextStyle(
          color: AppColors.ruaWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        CircleButton(
          icon: CircleButtonIcon.exit,
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 10),
      ],
    ),
    body: Column(
      children: [
        // Seção "Mais procurados" (só aparece quando não está pesquisando)
        if (!_isSearching) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mais procurados',
                style: TextStyle(
                  color: AppColors.ruaWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _allImages.take(5).length,
              itemBuilder: (context, index) {
                final image = _allImages[index];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => _openArtDetail(image),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              image.url,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          image.title,
                          style: TextStyle(
                            color: AppColors.ruaWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Barra de busca com efeito blur
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.halfWhite,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _performSearch,
                  style: TextStyle(color: AppColors.ruaWhite),
                  decoration: InputDecoration(
                    hintText: 'Busque por aqui...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[400]),
                              onPressed: _clearSearch,
                            )
                            : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Lista de resultados (sempre renderizada, mas com conteúdo condicional)
        Expanded(
          child:
              _isSearching
                  ? (_filteredImages.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              color: Colors.grey[400],
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum resultado encontrado',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredImages.length,
                        itemBuilder: (context, index) {
                          final image = _filteredImages[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () => _openArtDetail(image),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[700]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Imagem da obra
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          image.url,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    color: Colors.grey[800],
                                                    child: const Icon(
                                                      Icons.error,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Informações da obra
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            image.title,
                                            style: TextStyle(
                                              color: AppColors.ruaWhite,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            image.types
                                                .map((type) => type.label)
                                                .join(', '),
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'R\$ 17,90', // Preço fixo por enquanto
                                            style: TextStyle(
                                              color: AppColors.ruaWhite,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Ícone de seta
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey[400],
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ))
                  : const SizedBox.shrink(), // Widget vazio quando não está pesquisando
        ),
      ],
    ),
  );

  void _openArtDetail(ImageItem imageItem) => Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder:
          (context, animation, secondaryAnimation) => BlocProvider(
            create:
                (context) => ImageVariationCubit()..loadImageItem(imageItem),
            child: ArtDetailPage(imageItem: imageItem),
          ),
      transitionsBuilder:
          (context, animation, secondaryAnimation, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: child,
          ),
      transitionDuration: const Duration(milliseconds: 300),
    ),
  );

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
