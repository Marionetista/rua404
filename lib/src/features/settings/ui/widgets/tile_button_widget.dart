import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/colors/app_colors.dart';

class TileButton extends StatelessWidget {
  const TileButton({
    required this.onTap,
    required this.iconUrl,
    required this.title,
    super.key,
  });

  final Function()? onTap;
  final String iconUrl;
  final String title;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      onTap?.call();
    },
    child: ListTile(
      tileColor: Colors.transparent,
      leading: Image.asset(iconUrl, width: 24, height: 24, fit: BoxFit.contain),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.ruaWhite,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_sharp, color: AppColors.ruaWhite),
    ),
  );
}
