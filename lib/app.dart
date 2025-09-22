import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/features/bag/logic/bag_cubit.dart';
import 'src/features/home/ui/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => BagCubit()..initialize(),
    child: MaterialApp(
      title: 'RuA404',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const HomePage(),
    ),
  );
}
