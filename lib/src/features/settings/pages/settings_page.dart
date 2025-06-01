import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/widgets/blured_button.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../../utils/app_utils.dart';
import '../widgets/tile_button_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    extendBodyBehindAppBar: true,
    extendBody: true,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      leading: Text('RuA404', style: TextStyle(color: AppColors.ruaWhite)),
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
              spacing: 12,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Configurações',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.ruaWhite,
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
                    style: TextStyle(
                      color: AppColors.ruaWhite,
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
