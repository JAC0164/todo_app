import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';

class NavigationButtons extends StatelessWidget {
  final int step;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const NavigationButtons({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedOpacity(
            opacity: step > 0 ? 1 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: TextButton(
              onPressed: step > 0 ? onBack : null,
              child: Text(
                'BACK',
                style: GoogleFonts.lato(
                  color: const Color.fromRGBO(255, 255, 255, 0.44),
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Constants.primaryColor,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                step < totalSteps - 1 ? 'NEXT' : 'GET STARTED',
                key: ValueKey(step < totalSteps - 1 ? 'NEXT' : 'GET STARTED'),
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
