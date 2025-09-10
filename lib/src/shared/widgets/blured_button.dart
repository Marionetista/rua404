import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/app_colors.dart';

class BlurTextButton extends StatelessWidget {
  const BlurTextButton({
    required this.text,
    super.key,
    this.onTap,
    this.textColor,
  });

  final String text;
  final VoidCallback? onTap;
  final Color? textColor;

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
            color: AppColors.halfWhite,
            borderRadius: BorderRadius.circular(48),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? AppColors.ruaWhite,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}
