import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/widgets/blured_button.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../calendar/pages/calendar_page.dart';
import '../../settings/pages/settings_page.dart';
import 'bullet_button_widget.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            10,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: BulletButton(
                label: 'Tag $index',
                onTap: () {},
                isSelected: index == 1 ? true : false,
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              top: BorderSide(color: AppColors.halfWhite, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: BlurTextButton(
                    text: 'Busque por aqui',
                    textColor: Colors.white.withValues(alpha: 0.5),
                    onTap:
                        () => Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
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
                            transitionDuration: const Duration(
                              milliseconds: 200,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const SettingsPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) => FadeTransition(
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
      ),
    ],
  );
}
