import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSkip;

  const CustomAppBar({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.bgColor,
      leading: TextButton(
        onPressed: onSkip,
        child: Text(
          'SKIP',
          style: GoogleFonts.lato(
            color: const Color.fromRGBO(255, 255, 255, 0.44),
            fontSize: 18,
          ),
        ),
      ),
      leadingWidth: 63,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
