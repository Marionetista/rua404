import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../enums/filter_type.dart';

class FlyingCover extends StatefulWidget {
  const FlyingCover({
    required this.onTap,
    super.key,
    this.imgUrl,
    this.width = 250,
    this.height = 300,
    this.imageTypes = const [],
  });

  final String? imgUrl;
  final VoidCallback onTap;
  final double width;
  final double height;
  final List<FilterType> imageTypes;

  @override
  State<FlyingCover> createState() => _FlyingCoverState();
}

class _FlyingCoverState extends State<FlyingCover>
    with TickerProviderStateMixin {
  late AnimationController _flyAwayController;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  // Controle de pan (movimento suave)
  Offset _panOffset = Offset.zero;
  bool _hasFlownAway = false;

  // Variáveis para o efeito de giroscópio
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  double _gyroX = 0.0;
  double _gyroY = 0.0;
  double _gyroZ = 0.0;
  bool _hasGyroscopeEffect = false;

  @override
  void initState() {
    super.initState();

    // Verificar se a imagem é do tipo Print ou Sticker para giroscópio
    _hasGyroscopeEffect =
        widget.imageTypes.contains(FilterType.prints) ||
        widget.imageTypes.contains(FilterType.stickers);

    // Verificar se a imagem é do tipo Holográfico

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

    // Configurar giroscópio se necessário
    if (_hasGyroscopeEffect) {
      _setupGyroscope();
    }
  }

  void _flyAway() {
    if (_hasFlownAway) return;

    setState(() => _hasFlownAway = true);
    _flyAwayController.forward().whenComplete(() => widget.onTap());
  }

  void _handlePanStart(DragStartDetails details) {
    // Não faz nada no início do pan
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_hasFlownAway) return;

    setState(() => _panOffset += details.delta);

    // Se arrastou muito para cima, inicia o voo
    if (_panOffset.dy < -100) {
      _flyAway();
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_hasFlownAway) return;

    // Se a velocidade for alta para cima, inicia o voo
    if (details.velocity.pixelsPerSecond.dy < -500) {
      _flyAway();
    } else {
      // Retorna para a posição original com animação suave
      setState(() => _panOffset = Offset.zero);
    }
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
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Transform.translate(
        offset: _panOffset,
        child:
            _hasGyroscopeEffect
                ? _buildGyroscopeTransform()
                : _buildNormalContainer(),
      ),
    );
  }

  Widget _buildNormalContainer() => Container(
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
  );

  Widget _buildGyroscopeTransform() {
    // Calcular as transformações 3D baseadas no giroscópio
    final double rotationX =
        _gyroY * 0.1; // Rotação em X baseada no movimento Y
    final double rotationY =
        _gyroX * 0.1; // Rotação em Y baseada no movimento X
    final double rotationZ =
        _gyroZ * 0.05; // Rotação em Z baseada no movimento Z

    // Calcular offset para efeito de paralaxe
    final double offsetX = _gyroX * 20;
    final double offsetY = _gyroY * 20;

    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspectiva
            ..rotateX(rotationX)
            ..rotateY(rotationY)
            ..rotateZ(rotationZ),
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
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
    );
  }

  void _setupGyroscope() {
    _gyroscopeSubscription = gyroscopeEventStream().listen((
      GyroscopeEvent event,
    ) {
      if (mounted) {
        setState(() {
          // Suavizar os valores do giroscópio para um efeito mais natural
          _gyroX = _gyroX * 0.8 + event.x * 0.2;
          _gyroY = _gyroY * 0.8 + event.y * 0.2;
          _gyroZ = _gyroZ * 0.8 + event.z * 0.2;
        });
      }
    });
  }

  @override
  void dispose() {
    _flyAwayController.dispose();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }
}
