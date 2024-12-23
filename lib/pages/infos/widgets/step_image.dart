import 'package:flutter/material.dart';

class StepImage extends StatelessWidget {
  final int step;
  final bool isForward;

  const StepImage({super.key, required this.step, required this.isForward});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: Image.asset(
        "assets/images/infos_illustration_${step + 1}.png",
        key: ValueKey(step), // Ensure each step has a unique key
        height: 278,
        width: 213,
      ),
    );
  }
}
