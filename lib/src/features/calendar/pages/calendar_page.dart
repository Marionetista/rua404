import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../../utils/app_utils.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    extendBodyBehindAppBar: true,
    extendBody: true,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      leading: const Text('RuA404', style: TextStyle(color: Colors.white)),
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
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/images/noEventsImg.svg'),
              const SizedBox(height: 14),
              const Text(
                'Sem eventos futuros :(',
                style: TextStyle(
                  color: Colors.white,
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
      ],
    ),
  );
}
