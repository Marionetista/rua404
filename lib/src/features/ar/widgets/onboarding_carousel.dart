import 'package:flutter/material.dart';

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    const OnboardingItem(
      title: 'Como usar os filtros AR',
      description:
          'Aponte a câmera para a imagem target e veja a mágica acontecer!',
    ),
    const OnboardingItem(
      title: 'Encontre as imagens',
      description:
          'Procure por imagens especiais espalhadas pelos eventos da Rua404',
    ),
    const OnboardingItem(
      title: 'Aponte e capture',
      description:
          'Mantenha a câmera estável sobre a imagem para melhor experiência',
    ),
    const OnboardingItem(
      title: 'Compartilhe suas conquistas',
      description: 'Colete badges exclusivas e mostre para seus amigos!',
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.view_in_ar,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),

      const SizedBox(height: 16),

      // Page indicators
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _items.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  _currentPage == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    ],
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingItem {
  const OnboardingItem({required this.title, required this.description});

  final String title;
  final String description;
}
