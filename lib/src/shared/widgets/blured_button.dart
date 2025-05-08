import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/app_colors.dart';

class BlurTextButton extends StatelessWidget {
  const BlurTextButton({required this.text, super.key, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(48),
          highlightColor: Colors.transparent,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.halfWhite,
              borderRadius: BorderRadius.circular(48),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({super.key});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  bool isSearching = false;
  final Duration duration = const Duration(milliseconds: 300);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    height: 48,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(255, 255, 255, 0.16),
      borderRadius: BorderRadius.circular(48),
      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
    ),
    child: InkWell(
      onTap: () => setState(() => isSearching = true),
      borderRadius: BorderRadius.circular(48),
      child: AnimatedSwitcher(
        duration: duration,
        transitionBuilder:
            (child, anim) => FadeTransition(
              opacity: anim,
              child: SizeTransition(
                sizeFactor: anim,
                axis: Axis.horizontal,
                child: child,
              ),
            ),
        child:
            isSearching
                ? Row(
                  key: const ValueKey('input'),
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Digite para buscar',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed:
                          () => setState(() {
                            isSearching = false;
                            _controller.clear();
                          }),
                    ),
                  ],
                )
                : const Padding(
                  key: ValueKey('button'),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      'Busque por aqui',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
      ),
    ),
  );
}
