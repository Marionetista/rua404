import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/colors/app_colors.dart';
import '../../../../shared/widgets/blured_button.dart';
import '../../../../shared/widgets/circle_button.dart';
import '../../../../utils/app_utils.dart';
import '../../logic/bag_cubit.dart';
import '../../logic/bag_state.dart';
import '../widgets/bag_card_widget.dart';
import '../widgets/bag_empty_widget.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  void _showClearBagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            backgroundColor: Colors.black.withValues(alpha: 0.9),
            title: Text(
              'Limpar Sacola',
              style: TextStyle(color: AppColors.ruaWhite),
            ),
            content: Text(
              'Tem certeza que deseja remover todos os itens da sacola?',
              style: TextStyle(color: AppColors.greyText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: AppColors.greyText),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<BagCubit>().clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Confirmar',
                  style: TextStyle(color: AppColors.ruaWhite),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
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
    body: Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
          child: Container(color: Colors.black.withValues(alpha: 0.4)),
        ),
        BlocBuilder<BagCubit, BagState>(
          builder: (context, state) {
            if (state is! BagLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isEmpty) {
              return const BagEmptyWidget();
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top:
                        AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        16,
                    left: 16,
                    right: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 10.0,
                        children: [
                          Text(
                            'Sua sacola (${state.totalItems})',
                            style: TextStyle(
                              color: AppColors.ruaWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          InkWell(
                            onTap: () => _showClearBagDialog(context),
                            child: Row(
                              spacing: 10.0,
                              children: [
                                Text(
                                  'Limpar',
                                  style: TextStyle(
                                    color: AppColors.ruaWhite,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/trash.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  sliver: SliverList.separated(
                    itemCount: state.items.length,
                    separatorBuilder:
                        (_, __) =>
                            const Divider(color: Colors.white24, thickness: 1),
                    itemBuilder:
                        (_, index) =>
                            BagCardWidget(bagItem: state.items[index]),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlurTextButton(
                          text: 'Adicionar mais itens',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            );
          },
        ),
      ],
    ),

    bottomNavigationBar: BlocBuilder<BagCubit, BagState>(
      builder: (context, state) {
        if (state is! BagLoaded || state.isEmpty) {
          return const SizedBox.shrink();
        }

        return Visibility(
          visible: !state.isEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(color: AppColors.halfWhite, width: 1),
                    ),
                  ),
                  child: Row(
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
                            AppUtils.formatCurrency(state.subtotal),
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
                                'Comprar',
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
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
