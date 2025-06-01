import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../utils/app_utils.dart';

class EmptyCalendarWidget extends StatelessWidget {
  const EmptyCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 50.0),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/noEventsImg.svg'),
          const SizedBox(height: 14),
          Text(
            'Sem eventos futuros :(',
            style: TextStyle(
              color: AppColors.ruaWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mas estamos sempre abertos a propostas!',
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
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  AppUtils.openEmail();
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
                    'Chame a gente!',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
