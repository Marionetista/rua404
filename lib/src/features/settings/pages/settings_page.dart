import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/widgets/blured_button.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../../utils/app_utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight * 2),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Configurações',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const TileButton(
                  iconUrl: 'assets/icons/etprofile.png',
                  title: 'Perfil',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: AppColors.halfWhite),
                ),
                const TileButton(
                  iconUrl: 'assets/icons/pedidos.png',
                  title: 'Pedidos',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: AppColors.halfWhite),
                ),
                const TileButton(
                  iconUrl: 'assets/icons/pagamentos.png',
                  title: 'Meios de pagamento',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: AppColors.halfWhite),
                ),
                const TileButton(
                  iconUrl: 'assets/icons/notificacao.png',
                  title: 'Notificações',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: AppColors.halfWhite),
                ),
                const TileButton(
                  iconUrl: 'assets/icons/terms.png',
                  title: 'Termos e privacidade',
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Versão',
                style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              FutureBuilder(
                future: AppUtils.getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  return Text(
                    '${snapshot.data}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
          Row(children: [BlurTextButton(text: 'Sair', onTap: () {})]),
        ],
      ),
    ),
  );
}

class TileButton extends StatelessWidget {
  const TileButton({required this.iconUrl, required this.title, super.key});

  final String iconUrl;
  final String title;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Image.asset(iconUrl, width: 24, height: 24, fit: BoxFit.contain),
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
  );
}
