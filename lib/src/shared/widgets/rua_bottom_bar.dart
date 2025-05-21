import 'package:flutter/material.dart';
import '../../features/calendar/pages/calendar_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../colors/app_colors.dart';
import 'blured_button.dart';
import 'circle_button.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: AppColors.halfWhite, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: BlurTextButton(
                text: 'Busque por aqui',
                onTap:
                    () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const CalendarPage(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          final tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: Curves.easeOut));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    ),
              ),
            ),
          ),
          Row(
            spacing: 10,
            children: [
              const CircleButton(icon: CircleButtonIcon.aircon),
              CircleButton(
                icon: CircleButtonIcon.profile,
                onTap:
                    () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const SettingsPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
