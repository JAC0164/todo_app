import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleLoginRegister extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const ToggleLoginRegister({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account?" : "Already have an account?",
          style: GoogleFonts.lato(
            color: const Color(0xFF979797),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onToggle,
          child: Text(
            isLogin ? 'Register' : 'Login',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
