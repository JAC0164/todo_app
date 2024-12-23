import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepContent extends StatelessWidget {
  final String title;
  final String description;

  const StepContent({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            title,
            key: UniqueKey(), // Use UniqueKey for proper updates
            style: GoogleFonts.lato(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            description,
            key: UniqueKey(), // Use UniqueKey for proper updates
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 18,
              color: const Color.fromRGBO(255, 255, 255, 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
