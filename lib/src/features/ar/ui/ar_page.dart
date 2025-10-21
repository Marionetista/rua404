import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/widgets/circle_button.dart';
import '../services/ar_config_service.dart';
import '../widgets/badges_section.dart';
import '../widgets/onboarding_carousel.dart';

class ARPage extends StatefulWidget {
  const ARPage({super.key});

  @override
  State<ARPage> createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  static const MethodChannel _channel = MethodChannel('com.rua404.ar/methods');

  bool _isLoading = true;
  bool _isARActive = false;
  String? _errorMessage;
  // bool _showOnboardingAndBadges = false;

  @override
  void initState() {
    super.initState();
    // _setupMethodChannel();
    _initializeAR();
  }

  @override
  void dispose() {
    _stopAR();
    super.dispose();
  }

  // void _setupMethodChannel() {
  //   _channel.setMethodCallHandler((call) async {
  //     switch (call.method) {
  //       case 'onTargetDetected':
  //         _onTargetDetected(call.arguments['targetId']);
  //         break;
  //       case 'onTargetLost':
  //         _onTargetLost();
  //         break;
  //       case 'onError':
  //         _onError(call.arguments['error']);
  //         break;
  //     }
  //   });
  // }

  Future<void> _initializeAR() async {
    try {
      // Load first available target for testing
      final targets = await ARConfigService.getAllTargets();
      if (targets.isNotEmpty) {
        await _startAR();
      } else {
        setState(() {
          _errorMessage = 'Nenhum target AR configurado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar configuração AR: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _startAR() async {
    try {
      await _channel.invokeMethod('startAR');
      setState(() {
        _isARActive = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao iniciar AR: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _stopAR() async {
    if (_isARActive) {
      try {
        await _channel.invokeMethod('stopAR');
        if (mounted) {
          setState(() => _isARActive = false);
        }
      } catch (e) {
        print('Erro ao parar AR: $e');
      }
    }
  }

  // void _onTargetDetected(String targetId) {
  //   if (mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Target detectado: $targetId'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   }
  // }

  // void _onTargetLost() {
  //   if (mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Target perdido'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //   }
  // }

  // void _onError(String error) {
  //   if (mounted) {
  //     setState(() {
  //       _errorMessage = error;
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: const Text('Filtros AR', style: TextStyle(color: Colors.white)),
      actions: [
        CircleButton(
          icon: CircleButtonIcon.exit,
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 10),
      ],
    ),
    body: _buildBody(),
    floatingActionButton: CircleButton(
      icon: CircleButtonIcon.aircon,
      onTap: () {
        // _setupMethodChannel();
        _initializeAR();
      },
    ),
  );

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Iniciando AR...', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  _initializeAR();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return _buildOnboardingAndBadgesView();
  }

  Widget _buildOnboardingAndBadgesView() => SingleChildScrollView(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Error message (if any)
        if (_errorMessage != null) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_amber_outlined,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],

        // Carrossel de onboarding
        const OnboardingCarousel(),

        const SizedBox(height: 32),

        // Seção de badges
        const BadgesSection(),
      ],
    ),
  );
}
