import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/colors/app_colors.dart';

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isFutureEvent,
    super.key,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final bool isFutureEvent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16.0),
    width: double.infinity,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color:
                  isFutureEvent
                      ? Colors.transparent
                      : Colors.black.withValues(alpha: 0.7),
            ),
          ),
        ),

        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: AppColors.ruaWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: AppColors.greyText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        isFutureEvent
            ? SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ruaWhite,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                child: const Text(
                  'Confirmar presença',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
            : SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ruaWhite,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                child: const Text('Ver evento', style: TextStyle(fontSize: 16)),
              ),
            ),
      ],
    ),
  );
}
