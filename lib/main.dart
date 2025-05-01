import 'package:flutter/material.dart';

import 'src/shared/widgets/circle_button.dart';
import 'src/shared/widgets/rua_bottom_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'RuA404',
    theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
    home: const MyHomePage(title: 'Flutter Demo Home Page'),
    debugShowCheckedModeBanner: false,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      leading: const Text('RuA404', style: TextStyle(color: Colors.white)),
      actions: const [
        CircleButton(icon: CircleButtonIcon.calendar),
        SizedBox(width: 10),
        CircleButton(icon: CircleButtonIcon.bag),
      ],
    ),
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
            style: TextStyle(color: Colors.white),
          ),
          Text('oi', style: TextStyle(color: Colors.white)),
        ],
      ),
    ),
    bottomNavigationBar: const CustomBottomNavBar(),
  );
}
