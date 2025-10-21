import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';

class ARBadge extends Equatable {
  const ARBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.isUnlocked,
    required this.iconPath,
    required this.color,
    this.progress = 0.0,
  });

  final String id;
  final String name;
  final String description;
  final bool isUnlocked;
  final String iconPath;
  final Color color; // Color as Color object
  final double progress; // Progress towards next level (0.0 to 1.0)

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    isUnlocked,
    iconPath,
    color,
    progress,
  ];

  ARBadge copyWith({
    String? id,
    String? name,
    String? description,
    bool? isUnlocked,
    String? iconPath,
    Color? color,
    double? progress,
  }) => ARBadge(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    isUnlocked: isUnlocked ?? this.isUnlocked,
    iconPath: iconPath ?? this.iconPath,
    color: color ?? this.color,
    progress: progress ?? this.progress,
  );

  // Sample badges data
  static List<ARBadge> getSampleBadges() => [
    // Unlocked badges
    const ARBadge(
      id: 'ship_badge',
      name: 'Navegador',
      description: 'Primeiro filtro usado',
      isUnlocked: true,
      iconPath: 'assets/icons/ship.png',
      color: AppColors.minionYellow,
      progress: 0.7,
    ),
    const ARBadge(
      id: 'trophy_badge',
      name: 'Campeão',
      description: '5 filtros usados',
      isUnlocked: true,
      iconPath: 'assets/icons/trophy.png',
      color: AppColors.amethyst,
      progress: 0.4,
    ),
    const ARBadge(
      id: 'shield_badge',
      name: 'Protetor',
      description: '10 filtros usados',
      isUnlocked: true,
      iconPath: 'assets/icons/shield.png',
      color: AppColors.minionYellow,
      progress: 0.2,
    ),
    const ARBadge(
      id: 'diamond_badge',
      name: 'Diamante',
      description: '15 filtros usados',
      isUnlocked: true,
      iconPath: 'assets/icons/diamond.png',
      color: AppColors.capri,
      progress: 0.9,
    ),
    // Locked badges
    const ARBadge(
      id: 'star_badge',
      name: 'Estrela',
      description: '20 filtros usados',
      isUnlocked: false,
      iconPath: 'assets/icons/star.png',
      color: AppColors.seaGreenCrayola,
    ),
    const ARBadge(
      id: 'crown_badge',
      name: 'Rei',
      description: '25 filtros usados',
      isUnlocked: false,
      iconPath: 'assets/icons/crown.png',
      color: AppColors.amethyst,
    ),
    const ARBadge(
      id: 'fire_badge',
      name: 'Fogo',
      description: '30 filtros usados',
      isUnlocked: false,
      iconPath: 'assets/icons/fire.png',
      color: AppColors.minionYellow,
    ),
    const ARBadge(
      id: 'lightning_badge',
      name: 'Relâmpago',
      description: '35 filtros usados',
      isUnlocked: false,
      iconPath: 'assets/icons/lightning.png',
      color: AppColors.capri,
    ),
    const ARBadge(
      id: 'heart_badge',
      name: 'Coração',
      description: '40 filtros usados',
      isUnlocked: false,
      iconPath: 'assets/icons/heart.png',
      color: AppColors.amethyst,
    ),
    const ARBadge(
      id: 'gem_badge',
      name: 'Gema',
      description: '45 filtros usados',
      isUnlocked: false,
      iconPath: 'assets/icons/gem.png',
      color: AppColors.magentaCrayola,
    ),
    const ARBadge(
      id: 'moon_badge',
      name: 'Lua',
      description: '50 filtros usados',
      isUnlocked: false,
      iconPath: 'assets/icons/moon.png',
      color: AppColors.seaGreenCrayola,
    ),
    const ARBadge(
      id: 'sun_badge',
      name: 'Sol',
      description: '60 filtros usados',
      isUnlocked: false,
      iconPath: 'assets/icons/sun.png',
      color: AppColors.minionYellow,
    ),
  ];
}
