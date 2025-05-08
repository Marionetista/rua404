import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/app_colors.dart';

enum CircleButtonIcon { bag, addBag, calendar, profile, exit, aircon }

class CircleButton extends StatelessWidget {
  const CircleButton({
    required this.icon,
    this.splashColor,
    this.itemsCount = 0,
    this.onTap,
    super.key,
  });

  final CircleButtonIcon icon;
  final Color? splashColor;
  final int? itemsCount;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String assetName;
    switch (icon) {
      case CircleButtonIcon.bag:
        assetName = 'assets/icons/bag.png';
        break;
      case CircleButtonIcon.calendar:
        assetName = 'assets/icons/calendar.png';
        break;
      case CircleButtonIcon.profile:
        assetName = 'assets/icons/profile.png';
        break;
      case CircleButtonIcon.exit:
        assetName = 'assets/icons/exit.png';
        break;
      case CircleButtonIcon.aircon:
        assetName = 'assets/icons/ariconblack.png';
      case CircleButtonIcon.addBag:
        assetName = 'assets/icons/addBag.png';
        break;
    }

    return Tooltip(
      message: '',
      child: Badge(
        backgroundColor: Colors.white,
        textColor: Colors.black,
        label: Text(itemsCount.toString()),
        isLabelVisible: icon == CircleButtonIcon.bag,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(48),
          splashColor: splashColor ?? Colors.purpleAccent,
          highlightColor: Colors.transparent,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child:
                  icon == CircleButtonIcon.aircon
                      ? Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/foil.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/ariconblack.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                      : Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.halfWhite,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 0,
                          ),
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
            ),
          ),
        ),
      ),
    );
  }
}
