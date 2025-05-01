import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

enum CircleButtonIcon { bag, calendar, profile, exit, aircon }

class CircleButton extends StatelessWidget {
  const CircleButton({
    required this.icon,
    this.splashColor,
    this.fillColor,
    this.onTap,
    super.key,
  });

  final CircleButtonIcon icon;
  final Color? splashColor;
  final Color? fillColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String assetName;
    switch (icon) {
      case CircleButtonIcon.bag:
        assetName = 'assets/images/bag.png';
        break;
      case CircleButtonIcon.calendar:
        assetName = 'assets/images/calendar.png';
        break;
      case CircleButtonIcon.profile:
        assetName = 'assets/images/profile.png';
        break;
      case CircleButtonIcon.exit:
        assetName = 'assets/images/exit.png';
        break;
      case CircleButtonIcon.aircon:
        assetName = 'assets/images/aricon.png';
        break;
    }

    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(48),
      splashColor: splashColor ?? Colors.purpleAccent,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: fillColor?.withValues(alpha: .9) ?? AppColors.halfWhite,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            assetName,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
