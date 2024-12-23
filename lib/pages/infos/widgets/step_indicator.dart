import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({super.key, required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 10),
          width: currentStep == index ? 28 : 20, // Highlight current step
          height: 4,
          decoration: BoxDecoration(
            color: currentStep == index
                ? const Color.fromRGBO(255, 255, 255, 1)
                : const Color(0xFFAFAFAF),
            borderRadius: BorderRadius.circular(56),
          ),
        ),
      ),
    );
  }
}
