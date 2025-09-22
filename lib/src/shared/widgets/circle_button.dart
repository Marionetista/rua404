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
    String tooltip;
    switch (icon) {
      case CircleButtonIcon.bag:
        assetName = 'assets/icons/bag.png';
        tooltip = 'Sacola';
        break;
      case CircleButtonIcon.calendar:
        assetName = 'assets/icons/calendar.png';
        tooltip = 'Calendário de eventos';
        break;
      case CircleButtonIcon.profile:
        assetName = 'assets/icons/profile.png';
        tooltip = 'Perfil e configurações';
        break;
      case CircleButtonIcon.exit:
        assetName = 'assets/icons/exit.png';
        tooltip = 'Fechar';
        break;
      case CircleButtonIcon.aircon:
        assetName = 'assets/icons/ariconblack.png';
        tooltip = 'Filtros AR!';
      case CircleButtonIcon.addBag:
        assetName = 'assets/icons/addbag.png';
        tooltip = 'Adicionar na sacola';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Stack(
        children: [
          InkWell(
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
          if (icon == CircleButtonIcon.bag && (itemsCount ?? 0) > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.ruaWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  (itemsCount ?? 0).toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CircleFavoriteButton extends StatelessWidget {
  const CircleFavoriteButton({
    this.splashColor,
    this.onTap,
    this.isFavorited = false,
    super.key,
  });

  final Color? splashColor;
  final Function()? onTap;
  final bool isFavorited;

  @override
  Widget build(BuildContext context) => InkWell(
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
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.halfWhite,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.transparent, width: 0),
          ),
          child: Center(
            child: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : AppColors.ruaWhite,
              size: 24,
            ),
          ),
        ),
      ),
    ),
  );
}
