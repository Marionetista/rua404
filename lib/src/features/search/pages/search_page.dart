import 'package:flutter/material.dart';

import '../../../shared/widgets/circle_button.dart';
import '../../../shared/widgets/rua_bottom_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      leading: const Text('RuA404', style: TextStyle(color: Colors.white)),
      actions: [
        CircleButton(
          icon: CircleButtonIcon.exit,
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 20),
      ],
    ),
    bottomNavigationBar: const CustomBottomNavBar(),
  );
}
