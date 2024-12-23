import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';

class Badge extends StatelessWidget {
  final String label;
  final bool isOutlined;

  const Badge({
    super.key,
    required this.label,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutlined ? const Color(0xFF363636) : Constants.primaryColor,
        borderRadius: BorderRadius.circular(4),
        border: isOutlined ? Border.all(color: Constants.primaryColor) : null,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
