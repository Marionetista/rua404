import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';

class BagCardWidget extends StatefulWidget {
  const BagCardWidget({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imagePath,
    super.key,
  });

  final String title;
  final String subtitle;
  final String price;
  final String imagePath;

  @override
  State<BagCardWidget> createState() => _BagCardWidgetState();
}

class _BagCardWidgetState extends State<BagCardWidget> {
  int _counter = 0;
  var width = 0.0;
  void _incrementCounter() => setState(() => _counter++);
  void _decrementCounter() => setState(() => _counter--);

  @override
  Widget build(BuildContext context) => Container(
    width: 361,
    height: 109,
    decoration: const BoxDecoration(color: Colors.transparent),
    child: Row(
      children: [
        SizedBox(
          height: 109,
          width: 109,
          child: Image.asset(widget.imagePath, fit: BoxFit.cover),
        ),

        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: AppColors.ruaWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.subtitle,
                      style: TextStyle(color: AppColors.greyText, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.price,
                      style: TextStyle(
                        color: AppColors.ruaWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(bottom: 8, right: 8, child: newCard()),
            ],
          ),
        ),
      ],
    ),
  );

  Widget newCard() => ClipRRect(
    borderRadius: BorderRadius.circular(48),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: 48,
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.halfWhite,
          borderRadius: BorderRadius.circular(48),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                if (_counter == 1) {
                  setState(() => _counter = 0);
                } else {
                  _decrementCounter();
                }
              },
              child: Image.asset(
                _counter == 1
                    ? 'assets/icons/trash.png'
                    : 'assets/icons/remove.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '$_counter',
                style: TextStyle(
                  color: AppColors.ruaWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: _incrementCounter,
              child: Image.asset(
                'assets/icons/add.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
