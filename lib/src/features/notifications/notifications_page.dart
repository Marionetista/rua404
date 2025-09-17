import 'dart:ui';
import 'package:flutter/material.dart';

import '../../shared/colors/app_colors.dart';
import '../../shared/widgets/circle_button.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Notificação por
  bool mobileNotifications = true;
  bool emailNotifications = true;

  // Tipos de notificações
  bool newEvents = true;
  bool promotions = true;
  bool newProducts = true;
  bool restockFavorites = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    extendBodyBehindAppBar: true,
    extendBody: true,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
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
        Padding(
          padding: EdgeInsets.only(
            top:
                AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Configurações de Notificações',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.ruaWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Seção: Notificação por
                _buildSectionTitle('Notificação por'),
                _buildSwitchTile(
                  'Celular',
                  'Receba notificações no seu telefone celularizado',
                  mobileNotifications,
                  (value) => setState(() => mobileNotifications = value),
                ),
                _buildSwitchTile(
                  'Email',
                  'Receba notificações por email',
                  emailNotifications,
                  (value) => setState(() => emailNotifications = value),
                ),

                const SizedBox(height: 32),

                // Seção: Tipos de notificações
                _buildSectionTitle('Tipos de notificações'),
                _buildSwitchTile(
                  'Promoções',
                  'Notificações sobre ofertas e promoções especiais',
                  promotions,
                  (value) => setState(() => promotions = value),
                ),
                _buildSwitchTile(
                  'Novos produtos',
                  'Notificações sobre lançamentos de produtos',
                  newProducts,
                  (value) => setState(() => newProducts = value),
                ),
                _buildSwitchTile(
                  'Reestoque de produtos favoritados',
                  'Notificações quando seus produtos favoritos voltam ao estoque!',
                  restockFavorites,
                  (value) => setState(() => restockFavorites = value),
                ),
                _buildSwitchTile(
                  'Novos eventos',
                  'Notificações sobre novos eventos disponíveis',
                  newEvents,
                  (value) => setState(() => newEvents = value),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Text(
      title,
      style: TextStyle(
        color: AppColors.ruaWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
    child: SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.ruaWhite,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.greyText,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.ruaWhite,
      inactiveThumbColor: AppColors.greyText,
      inactiveTrackColor: AppColors.halfWhite,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
    ),
  );
}
