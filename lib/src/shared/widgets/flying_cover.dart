import 'dart:math';
import 'package:flutter/material.dart';

class FlyingCover extends StatefulWidget {
  const FlyingCover({
    required this.onTap,
    super.key,
    this.imgUrl,
    this.width = 250,
    this.height = 300,
  });

  final String? imgUrl;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  State<FlyingCover> createState() => _FlyingCoverState();
}

class _FlyingCoverState extends State<FlyingCover>
    with TickerProviderStateMixin {
  late AnimationController _flyAwayController;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  // Controle de zoom e pan
  late TransformationController _transformationController;

  bool _hasFlownAway = false;
  bool _isZoomed = false;
  Offset _panOffset = Offset.zero;
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();

    _transformationController = TransformationController();

    // Controller para animação de voo
    _flyAwayController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animação de voo
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -3.0), // Vai para fora da tela
    ).animate(
      CurvedAnimation(parent: _flyAwayController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: pi / 3, // Gira 60°
    ).animate(
      CurvedAnimation(parent: _flyAwayController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3, // Diminui ao voar
    ).animate(
      CurvedAnimation(parent: _flyAwayController, curve: Curves.easeOut),
    );
  }

  void _flyAway() {
    if (_hasFlownAway) return;

    setState(() => _hasFlownAway = true);
    _flyAwayController.forward().whenComplete(() => widget.onTap());
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _scale;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_hasFlownAway) return;

    // Se é um gesto de escala (dois dedos), atualiza o zoom
    if (details.scale != 1.0) {
      setState(() {
        _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
      });
    }
    // Se é um gesto de pan (um dedo) e não está com zoom
    else if (!_isZoomed && details.focalPointDelta != Offset.zero) {
      setState(() {
        _panOffset += details.focalPointDelta;
      });

      // Se arrastou muito para cima, inicia o voo
      if (_panOffset.dy < -100) {
        _flyAway();
      }
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_hasFlownAway) return;

    _baseScale = _scale;

    // Se é um gesto de pan (um dedo) e não está com zoom
    if (!_isZoomed && details.velocity.pixelsPerSecond != Offset.zero) {
      // Se a velocidade for alta para cima, inicia o voo
      if (details.velocity.pixelsPerSecond.dy < -500) {
        _flyAway();
      } else {
        // Retorna para a posição original
        setState(() {
          _panOffset = Offset.zero;
        });
      }
    }
    // Se é um gesto de escala
    else {
      // Se o zoom for muito pequeno, volta ao normal
      if (_scale < 0.8) {
        setState(() {
          _scale = 1.0;
          _baseScale = 1.0;
          _isZoomed = false;
        });
      } else if (_scale > 1.2) {
        setState(() {
          _isZoomed = true;
        });
      } else {
        setState(() {
          _scale = 1.0;
          _baseScale = 1.0;
          _isZoomed = false;
        });
      }
    }
  }

  void _doubleTapZoom() {
    if (_hasFlownAway) return;

    setState(() {
      if (_isZoomed) {
        _scale = 1.0;
        _baseScale = 1.0;
        _isZoomed = false;
      } else {
        _scale = 2.0;
        _baseScale = 2.0;
        _isZoomed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasFlownAway) {
      return AnimatedBuilder(
        animation: _flyAwayController,
        builder:
            (context, child) => Transform.translate(
              offset:
                  _positionAnimation.value * MediaQuery.of(context).size.height,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Center(
                    child: Image.asset(
                      widget.imgUrl ?? 'assets/images/pimp.png',
                      width: widget.width,
                      height: widget.height,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
      );
    }

    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      onDoubleTap: _doubleTapZoom,
      child: Transform.translate(
        offset: _panOffset,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.imgUrl ?? 'assets/images/pimp.png',
                width: widget.width,
                height: widget.height,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flyAwayController.dispose();
    _transformationController.dispose();
    super.dispose();
  }
}
