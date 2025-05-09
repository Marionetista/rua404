import 'dart:math';

import 'package:flutter/material.dart';

class FlyingCover extends StatefulWidget {
  const FlyingCover({required this.onTap, super.key, this.imgUrl});

  final String? imgUrl;
  final VoidCallback onTap;

  @override
  State<FlyingCover> createState() => _FlyingCoverState();
}

class _FlyingCoverState extends State<FlyingCover>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;

  bool _hasFlownAway = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Vai para cima e para fora da tela
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2.5), // -2.5 altura da tela
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: pi / 2, // gira 90°
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void _flyAway() {
    setState(() => _hasFlownAway = true);
    _animationController.forward().whenComplete(() => widget.onTap());
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      if (!_hasFlownAway)
        GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -10) {
              _flyAway();
            }
          },
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors
                            .transparent, //Colors.white.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Image.asset(widget.imgUrl!, width: 200),
            ),
          ),
        ),

      if (_hasFlownAway)
        AnimatedBuilder(
          animation: _animationController,
          builder:
              (context, child) => Transform.translate(
                offset:
                    _positionAnimation.value *
                    MediaQuery.of(context).size.height,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Center(
                    child: Image.asset(
                      widget.imgUrl ?? 'assets/images/pimp.png',
                      width: 200,
                    ),
                  ),
                ),
              ),
        ),
    ],
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
