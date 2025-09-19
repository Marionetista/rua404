import 'package:flutter/material.dart';

import 'src/features/home/ui/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'RuA404',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
    home: const HomePage(),
  );
}
