import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import 'badge_widget.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = ARBadge.getSampleBadges();

    // Sort badges: unlocked first, then locked
    final sortedBadges = [
      ...badges.where((b) => b.isUnlocked),
      ...badges.where((b) => !b.isUnlocked),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'CONQUISTAS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Badges grid - all badges in one list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: sortedBadges.length,
            itemBuilder: (context, index) {
              final badge = sortedBadges[index];
              return BadgeWidget(badge: badge);
            },
          ),
        ),
      ],
    );
  }
}
