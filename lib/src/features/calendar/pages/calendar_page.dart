import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/widgets/blured_button.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../../utils/app_utils.dart';
import '../widgets/empty_calendar_widget.dart';
import '../widgets/event_card_widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool isEmpty = false;

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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    'Eventos futuros',
                    style: TextStyle(
                      color: AppColors.ruaWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              if (isEmpty)
                const SliverToBoxAdapter(child: EmptyCalendarWidget()),

              if (!isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  sliver: SliverList.separated(
                    itemCount: 2,
                    separatorBuilder:
                        (_, __) =>
                            const Divider(color: Colors.white24, thickness: 1),
                    itemBuilder:
                        (_, index) => const EventCardWidget(
                          title: 'Festival de Colantes - 3ª edição',
                          subtitle: '16 de Novembro de 2024, Uberlândia',
                          imagePath: 'assets/images/festival.jpg',
                          isFutureEvent: true,
                        ),
                  ),
                ),

              if (!isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 20.0,
                      bottom: 40.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlurTextButton(
                          text: 'Chame a gente!',
                          onTap: () => AppUtils.openEmail(),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    'Eventos anteriores',
                    style: TextStyle(
                      color: AppColors.ruaWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                sliver: SliverList.separated(
                  itemCount: 1,
                  separatorBuilder:
                      (_, __) =>
                          const Divider(color: Colors.white24, thickness: 1),
                  itemBuilder:
                      (_, index) => const EventCardWidget(
                        title: 'Festival de Colantes - 3ª edição',
                        subtitle: '16 de Novembro de 2024, Uberlândia',
                        imagePath: 'assets/images/festival.jpg',
                        isFutureEvent: false,
                      ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20.0)),
            ],
          ),
        ),
      ],
    ),
  );
}
