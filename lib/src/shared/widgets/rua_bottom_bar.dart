import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import 'circle_button.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: AppColors.halfWhite, width: 0.5)),
      ),
      child: const Row(
        children: [
          Expanded(child: SizedBox()),
          Row(
            spacing: 10,
            children: [
              CircleButton(
                icon: CircleButtonIcon.aircon,
                fillColor: Colors.amber,
              ),
              CircleButton(icon: CircleButtonIcon.profile),
            ],
          ),
        ],
      ),
    ),
  );
}
