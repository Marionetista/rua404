import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/ar_config_service.dart';

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

  @override
  void initState() {
    super.initState();
    _setupMethodChannel();
    _initializeAR();
  }

  @override
  void dispose() {
    _stopAR();
    super.dispose();
  }

  void _setupMethodChannel() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onTargetDetected':
          _onTargetDetected(call.arguments['targetId']);
          break;
        case 'onTargetLost':
          _onTargetLost();
          break;
        case 'onError':
          _onError(call.arguments['error']);
          break;
      }
    });
  }

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

  void _onTargetDetected(String targetId) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Target detectado: $targetId'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _onTargetLost() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Target perdido'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onError(String error) {
    if (mounted) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('AR', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: _buildBody(),
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

    if (_isARActive) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_in_ar, color: Colors.green, size: 48),
            SizedBox(height: 16),
            Text(
              'AR ativo! Aponte a câmera para a imagem target.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text('Target: orelhudo', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return const Center(
      child: Text('AR não está ativo', style: TextStyle(color: Colors.white)),
    );
  }
}
