import 'package:flutter/material.dart';
import '../models/badge_model.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({required this.badge, this.size = 50.0, super.key});

  final ARBadge badge;
  final double size;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Badge circle
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: badge.color,
          boxShadow:
              badge.isUnlocked
                  ? [
                    BoxShadow(
                      color: badge.color.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : null,
        ),
        child: Opacity(
          opacity: badge.isUnlocked ? 1.0 : 0.3,
          child: Center(
            child: Icon(
              _getIconForBadge(badge.id),
              size: size * 0.3,
              color: Colors.white,
            ),
          ),
        ),
      ),

      SizedBox(height: size * 0.02),

      if (badge.isUnlocked)
        Container(
          width: size * 0.7,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: badge.progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: badge.color,
              ),
            ),
          ),
        ),
    ],
  );

  IconData _getIconForBadge(String badgeId) {
    switch (badgeId) {
      case 'ship_badge':
        return Icons.directions_boat;
      case 'trophy_badge':
        return Icons.emoji_events;
      case 'shield_badge':
        return Icons.shield;
      case 'diamond_badge':
        return Icons.diamond;
      case 'star_badge':
        return Icons.star;
      case 'crown_badge':
        return Icons.workspace_premium;
      case 'fire_badge':
        return Icons.local_fire_department;
      case 'lightning_badge':
        return Icons.flash_on;
      case 'heart_badge':
        return Icons.favorite;
      case 'gem_badge':
        return Icons.auto_awesome;
      case 'moon_badge':
        return Icons.nightlight_round;
      case 'sun_badge':
        return Icons.wb_sunny;
      default:
        return Icons.emoji_events;
    }
  }
}
