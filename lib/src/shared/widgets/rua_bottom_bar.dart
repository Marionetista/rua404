import 'package:flutter/material.dart';
import '../../features/search/pages/search_page.dart';
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
            child: BlurTextButton(
              text: 'Busque por aqui',
              onTap:
                  () => Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const SearchPage(),
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
          const Row(
            spacing: 10,
            children: [
              CircleButton(icon: CircleButtonIcon.aircon),
              CircleButton(icon: CircleButtonIcon.profile),
            ],
          ),
        ],
      ),
    ),
  );
}
