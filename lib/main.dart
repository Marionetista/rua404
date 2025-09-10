import 'package:flutter/material.dart';

import 'src/features/home/pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'RuA404',
    theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
    home: const MyHomePage(),
    debugShowCheckedModeBanner: false,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => const HomePage();
}
