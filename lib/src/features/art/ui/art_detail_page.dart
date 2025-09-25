import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/cubits/image_variation/image_variation_cubit.dart';
import '../../../shared/cubits/image_variation/image_variation_state.dart';
import '../../../shared/models/image_item_model.dart';
import '../../../shared/utils/app_utils.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../../shared/widgets/variation_selection_widget.dart';
import '../../ar/ui/ar_page.dart';
import '../../bag/logic/bag_cubit.dart';
import '../../bag/logic/bag_state.dart';

class ArtDetailPage extends StatelessWidget {
  const ArtDetailPage({required this.imageItem, super.key});

  final ImageItem imageItem;

  Widget _buildSpecificationRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          color: AppColors.ruaWhite,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(value, style: TextStyle(color: AppColors.ruaWhite, fontSize: 14)),
    ],
  );

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<ImageVariationCubit, ImageVariationState>(
    builder: (context, state) {
      if (state is! ImageVariationLoaded) {
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final currentImageItem = state.imageItem;
      final selectedVariation =
          context.read<ImageVariationCubit>().selectedVariation ??
          currentImageItem;

      return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Text('RuA404', style: TextStyle(color: AppColors.ruaWhite)),
          actions: [
            CircleButton(
              icon: CircleButtonIcon.exit,
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top:
                AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top,
          ),
          child: CustomScrollView(
            slivers: [
              // Imagem principal estática
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Center(
                    child: Container(
                      width: currentImageItem.width,
                      height: currentImageItem.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          selectedVariation.url,
                          width: currentImageItem.width,
                          height: currentImageItem.height,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: currentImageItem.width,
                                height: currentImageItem.height,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Conteúdo da página
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header com título e tipo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedVariation.title,
                              style: TextStyle(
                                color: AppColors.ruaWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedVariation.getImageTypeText(
                                selectedVariation,
                              ),
                              style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: CircleFavoriteButton(isFavorited: true),
                            ),
                            if (currentImageItem.hasARFilter)
                              CircleButton(
                                icon: CircleButtonIcon.aircon,
                                onTap:
                                    () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const ARPage(),
                                      ),
                                    ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Seção de variações
                    BlocProvider.value(
                      value: context.read<ImageVariationCubit>(),
                      child: const VariationSelectionWidget(),
                    ),
                    const SizedBox(height: 20),

                    // Sobre a peça
                    Text(
                      'Sobre a peça',
                      style: TextStyle(
                        color: AppColors.ruaWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      selectedVariation.description,
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Descrição técnica
                    Text(
                      'Descrição',
                      style: TextStyle(
                        color: AppColors.ruaWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tabela de especificações do produto
                    selectedVariation.hasAnyDescription
                        ? Column(
                          children: [
                            if ((selectedVariation.size ?? '').isNotEmpty) ...[
                              _buildSpecificationRow(
                                'Tamanho',
                                'Papel A3 (297 mm x 420 mm)',
                              ),
                              const Divider(color: Colors.grey, height: 20),
                            ],

                            if ((selectedVariation.weight ?? '')
                                .isNotEmpty) ...[
                              _buildSpecificationRow('Peso', '261g'),
                              const Divider(color: Colors.grey, height: 20),
                            ],

                            if ((selectedVariation.materialType ?? '')
                                .isNotEmpty) ...[
                              _buildSpecificationRow(
                                'Material',
                                'Papel liso 90g/m²',
                              ),
                              const Divider(color: Colors.grey, height: 20),
                            ],

                            if ((selectedVariation.printing ?? '')
                                .isNotEmpty) ...[
                              _buildSpecificationRow(
                                'Impressão',
                                'Preto e branco',
                              ),
                              const Divider(color: Colors.grey, height: 20),
                            ],

                            if (selectedVariation.isCollab)
                              _buildSpecificationRow('Collab', '@caxin'),
                          ],
                        )
                        : Center(
                          child: Text(
                            'Obra sem descrição',
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),

                    // Espaço extra para o bottom navigation
                    const SizedBox(height: 120),
                  ]),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: selectedVariation.isMarketable,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(color: AppColors.halfWhite, width: 1),
                    ),
                  ),
                  child: BlocBuilder<BagCubit, BagState>(
                    builder: (context, bagState) {
                      final subtotal =
                          bagState is BagLoaded ? bagState.subtotal : 0.0;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 1.0,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                AppUtils.formatCurrency(subtotal),
                                style: TextStyle(
                                  color: AppColors.ruaWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              InkWell(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  // Adiciona o produto à sacola com a variação atual
                                  context.read<BagCubit>().addItem(
                                    selectedVariation,
                                    selectedVariation.url,
                                  );
                                },
                                borderRadius: BorderRadius.circular(48),
                                highlightColor: AppColors.ruaWhite,
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.ruaWhite,
                                    borderRadius: BorderRadius.circular(48),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Adicionar ao carrinho',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
