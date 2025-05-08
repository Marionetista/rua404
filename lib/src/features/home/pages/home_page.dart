import 'package:flutter/material.dart';

import '../../../shared/widgets/circle_button.dart';
import '../../../shared/widgets/rua_bottom_bar.dart';
import '../widgets/infinite_canvas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: true,
    extendBody: true,
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      leading: const Text('RuA404', style: TextStyle(color: Colors.white)),
      actions: const [
        CircleButton(icon: CircleButtonIcon.calendar),
        SizedBox(width: 10),
        CircleButton(icon: CircleButtonIcon.bag),
        SizedBox(width: 20),
      ],
    ),
    body: const InfiniteCanvas(),

    bottomNavigationBar: const CustomBottomNavBar(),
  );
}
