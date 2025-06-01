import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/colors/app_colors.dart';

class BulletButton extends StatelessWidget {
  const BulletButton({
    required this.label,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(48),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(48),
        highlightColor: Colors.transparent,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.ruaWhite : AppColors.halfWhite,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : AppColors.ruaWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}
