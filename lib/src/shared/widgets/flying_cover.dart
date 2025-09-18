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

  // Controller para animação suave do giroscópio
  late AnimationController _gyroController;
  late Animation<double> _gyroXAnimation;
  late Animation<double> _gyroYAnimation;
  late Animation<double> _gyroZAnimation;

  // Controle de pan (movimento suave)
  Offset _panOffset = Offset.zero;
  bool _hasFlownAway = false;

  // Variáveis para o efeito de giroscópio
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  double _targetGyroX = 0.0;
  double _targetGyroY = 0.0;
  double _targetGyroZ = 0.0;
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

    // Controller para animação de voo
    _flyAwayController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Controller para animação suave do giroscópio
    _gyroController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Animações para suavizar os valores do giroscópio
    _gyroXAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _gyroController, curve: Curves.easeOut));
    _gyroYAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _gyroController, curve: Curves.easeOut));
    _gyroZAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _gyroController, curve: Curves.easeOut));

    // Listener para atualizar os valores atuais do giroscópio
    _gyroController.addListener(() {
      if (mounted) {
        setState(() {
          _gyroX = _gyroXAnimation.value;
          _gyroY = _gyroYAnimation.value;
          _gyroZ = _gyroZAnimation.value;
        });
      }
    });

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
    // Movimento natural em TODAS as direções (360°)

    // Criar deadzone para evitar micro-movimentos
    final double deadzone = 0.1;
    double effectiveGyroX = _gyroX.abs() > deadzone ? _gyroX : 0.0;
    double effectiveGyroY = _gyroY.abs() > deadzone ? _gyroY : 0.0;

    // Movimento ORTOGONAL 3D - inclinação natural sem efeito pêndulo
    // Determinar qual movimento é dominante (ortogonal)
    final double absX = effectiveGyroX.abs();
    final double absY = effectiveGyroY.abs();

    double rotationX = 0.0;
    double rotationY = 0.0;
    final double rotationZ = 0.0; // Não usar Z para evitar efeito pêndulo

    if (absX > absY) {
      // Movimento LATERAL dominante (esquerda/direita)
      // Inclina para direita → rotationX positivo (lado direito "afunda" em 3D)
      rotationX = effectiveGyroX * 0.25;
    } else if (absY > 0) {
      // Movimento VERTICAL dominante (cima/baixo)
      // Inclina para cima → rotationY negativo (parte de baixo "sobe" em 3D)
      rotationY = -effectiveGyroY * 0.25;
    }

    // Calcular offset para efeito de paralaxe mais sutil
    final double offsetX = effectiveGyroX * 6;
    final double offsetY = -effectiveGyroY * 6;

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
      if (mounted && !_hasFlownAway) {
        // Filtro mais leve para maior responsividade
        _targetGyroX = _targetGyroX * 0.5 + event.x * 0.5;
        _targetGyroY = _targetGyroY * 0.5 + event.y * 0.5;
        _targetGyroZ = _targetGyroZ * 0.5 + event.z * 0.5;

        // Limitar os valores para evitar movimentos muito extremos
        _targetGyroX = _targetGyroX.clamp(-3.0, 3.0);
        _targetGyroY = _targetGyroY.clamp(-3.0, 3.0);
        _targetGyroZ = _targetGyroZ.clamp(-3.0, 3.0);

        // Atualizar as animações com os novos valores target
        _gyroXAnimation = Tween<double>(
          begin: _gyroX,
          end: _targetGyroX,
        ).animate(
          CurvedAnimation(parent: _gyroController, curve: Curves.easeOutCubic),
        );

        _gyroYAnimation = Tween<double>(
          begin: _gyroY,
          end: _targetGyroY,
        ).animate(
          CurvedAnimation(parent: _gyroController, curve: Curves.easeOutCubic),
        );

        _gyroZAnimation = Tween<double>(
          begin: _gyroZ,
          end: _targetGyroZ,
        ).animate(
          CurvedAnimation(parent: _gyroController, curve: Curves.easeOutCubic),
        );

        // Resetar e iniciar a animação
        _gyroController.reset();
        _gyroController.forward();
      }
    });
  }

  @override
  void dispose() {
    _flyAwayController.dispose();
    _gyroController.dispose();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }
}
