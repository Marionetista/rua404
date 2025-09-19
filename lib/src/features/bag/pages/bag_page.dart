import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/enums/filter_type.dart';
import '../../../shared/models/image_item_model.dart';
import '../../../shared/widgets/blured_button.dart';
import '../../../shared/widgets/circle_button.dart';
import '../widgets/bag_card_widget.dart';
import '../widgets/bag_empty_widget.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  bool isEmpty = false;

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
        isEmpty
            ? const BagEmptyWidget()
            : Padding(
              padding: EdgeInsets.only(
                top:
                    AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 10.0,
                        children: [
                          Text(
                            'Sua sacola (2)',
                            style: TextStyle(
                              color: AppColors.ruaWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          InkWell(
                            onTap: () {},
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

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    sliver: SliverList.separated(
                      itemCount: 3,
                      separatorBuilder:
                          (_, __) => const Divider(
                            color: Colors.white24,
                            thickness: 1,
                          ),
                      itemBuilder:
                          (_, index) => const BagCardWidget(
                            product: ImageItem(
                              url: 'assets/images/pimp.png',
                              width: 220.0,
                              height: 180.0,
                              types: [
                                FilterType.classicos,
                                FilterType.prints,
                                FilterType.stickers,
                              ],
                              title: 'Pimp Classic',
                              description: 'Design clássico atemporal',
                              variations: ['assets/images/pimp.png'],
                              price: 20.0,
                            ),
                          ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlurTextButton(text: 'Adicionar mais itens'),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
      ],
    ),

    bottomNavigationBar: Visibility(
      visible: !isEmpty,
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
                        'R\$ 250,00',
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.ruaWhite,
                            borderRadius: BorderRadius.circular(48),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Comprar',
                            style: TextStyle(color: Colors.black, fontSize: 16),
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
    ),
  );
}
