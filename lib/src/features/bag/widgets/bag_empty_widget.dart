import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/colors/app_colors.dart';

class BagEmptyWidget extends StatelessWidget {
  const BagEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/images/sacolaVazia.svg'),
        const SizedBox(height: 14),
        const Text(
          'Vish, sua sacola está vazia...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bora adicionar alguns itens,\ntem muita coisa legal por aqui!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.greyText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
              },
              borderRadius: BorderRadius.circular(48),
              highlightColor: Colors.white,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(48),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Adicionar itens',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
