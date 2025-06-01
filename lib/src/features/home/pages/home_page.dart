import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../bag/pages/bag_page.dart';
import '../../calendar/pages/calendar_page.dart';
import '../widgets/rua_bottom_bar.dart';
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
      leading: Text('RuA404', style: TextStyle(color: AppColors.ruaWhite)),
      actions: [
        CircleButton(
          icon: CircleButtonIcon.calendar,
          onTap:
              () => Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const CalendarPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
        ),
        const SizedBox(width: 10),
        CircleButton(
          icon: CircleButtonIcon.bag,
          onTap:
              () => Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const BagPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              ),
        ),
        const SizedBox(width: 20),
      ],
    ),
    body: const InfiniteCanvas(),

    bottomNavigationBar: const CustomBottomNavBar(),
  );
}
