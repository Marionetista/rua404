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
  Offset _flyDirection = const Offset(0, -3.0); // Direção padrão: para cima

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

    // Controller para animação de voo (mais rápido)
    _flyAwayController = AnimationController(
      duration: const Duration(
        milliseconds: 800,
      ), // Mais rápido para fechar popup
      vsync: this,
    );

    // Controller para animação suave do giroscópio
    _gyroController = AnimationController(
      duration: const Duration(
        milliseconds: 150,
      ), // Equilibrio entre suavidade e responsividade
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

  void _flyAway([Offset? direction, double? gestureSpeed]) {
    if (_hasFlownAway) return;

    // Parar giroscópio imediatamente
    _gyroscopeSubscription?.cancel();
    _gyroController.stop();

    // Calcular velocidade e distância baseadas no gesto
    double speed = gestureSpeed ?? 600.0; // Velocidade padrão

    // Mapear velocidade para duração (mais rápido = menos tempo)
    // Velocidade mín: 500px/s = 1200ms, Velocidade máx: 3000px/s = 400ms
    double duration = (1600 - (speed - 500) * 0.4).clamp(400.0, 1200.0);

    // Mapear velocidade para distância em pixels (mais rápido = mais longe)
    double distanceInPixels = (speed * 0.8).clamp(400.0, 1200.0);

    // Definir direção e distância do voo
    if (direction != null) {
      _flyDirection = Offset(
        direction.dx * distanceInPixels,
        direction.dy * distanceInPixels,
      );
    }

    // Recriar o controller com nova duração
    _flyAwayController.dispose();
    _flyAwayController = AnimationController(
      duration: Duration(milliseconds: duration.round()),
      vsync: this,
    );

    // Recriar animações com nova direção e distância
    // Começar da posição atual do pan, não do centro
    _positionAnimation = Tween<Offset>(
      begin: _panOffset, // Começar de onde a imagem foi arrastada
      end: _panOffset + _flyDirection, // Voar a partir da posição atual
    ).animate(
      CurvedAnimation(parent: _flyAwayController, curve: Curves.easeOutCubic),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: pi / 3).animate(
      CurvedAnimation(parent: _flyAwayController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _flyAwayController, curve: Curves.easeOut),
    );

    setState(() => _hasFlownAway = true);
    _flyAwayController.forward().whenComplete(() => widget.onTap());
  }

  void _handlePanStart(DragStartDetails details) {
    // Não faz nada no início do pan
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_hasFlownAway) return;

    setState(() => _panOffset += details.delta);

    // Se arrastou muito em qualquer direção, inicia o voo
    final distance = _panOffset.distance;
    if (distance > 120) {
      // Calcular direção baseada no offset acumulado
      final normalizedOffset = _panOffset / distance;
      final flyDirection = Offset(normalizedOffset.dx, normalizedOffset.dy);

      // Estimar velocidade baseada na distância (movimento longo = velocidade média)
      double estimatedSpeed = (distance * 8).clamp(500.0, 2000.0);

      _flyAway(flyDirection, estimatedSpeed);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_hasFlownAway) return;

    final velocity = details.velocity.pixelsPerSecond;
    final speed = velocity.distance;

    // Se a velocidade for alta em qualquer direção, inicia o voo
    if (speed > 500) {
      // Calcular direção do voo baseada na velocidade
      final normalizedVelocity = velocity / speed;
      final flyDirection = Offset(normalizedVelocity.dx, normalizedVelocity.dy);

      // Usar a velocidade real do gesto
      _flyAway(flyDirection, speed);
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
                  _positionAnimation
                      .value, // Usar valor direto, já está em pixels
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

    // Deadzone menor para maior responsividade
    const double deadzone = 0.05;
    double effectiveGyroX = _gyroX.abs() > deadzone ? _gyroX : 0.0;
    double effectiveGyroY = _gyroY.abs() > deadzone ? _gyroY : 0.0;

    // Movimento ORTOGONAL 3D - inclinação natural sem efeito pêndulo
    // Determinar qual movimento é dominante (ortogonal)
    final double absX = effectiveGyroX.abs();
    final double absY = effectiveGyroY.abs();

    double rotationX = 0.0;
    double rotationY = 0.0;
    const double rotationZ = 0.0; // Não usar Z para evitar efeito pêndulo

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
        // Filtro equilibrado para suavidade sem travamentos
        _targetGyroX = _targetGyroX * 0.6 + event.x * 0.4;
        _targetGyroY = _targetGyroY * 0.6 + event.y * 0.4;
        _targetGyroZ = _targetGyroZ * 0.6 + event.z * 0.4;

        // Limitar os valores para evitar movimentos muito extremos
        _targetGyroX = _targetGyroX.clamp(-3.0, 3.0);
        _targetGyroY = _targetGyroY.clamp(-3.0, 3.0);
        _targetGyroZ = _targetGyroZ.clamp(-3.0, 3.0);

        // Atualizar as animações com os novos valores target
        _gyroXAnimation = Tween<double>(
          begin: _gyroX,
          end: _targetGyroX,
        ).animate(
          CurvedAnimation(parent: _gyroController, curve: Curves.easeOut),
        );

        _gyroYAnimation = Tween<double>(
          begin: _gyroY,
          end: _targetGyroY,
        ).animate(
          CurvedAnimation(parent: _gyroController, curve: Curves.easeOut),
        );

        _gyroZAnimation = Tween<double>(
          begin: _gyroZ,
          end: _targetGyroZ,
        ).animate(
          CurvedAnimation(parent: _gyroController, curve: Curves.easeOut),
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
