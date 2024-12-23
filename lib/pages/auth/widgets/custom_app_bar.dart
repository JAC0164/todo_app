import 'package:flutter/material.dart';
import 'package:todo_app/libs/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const CustomAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.bgColor,
      leadingWidth: 60,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left_outlined),
        iconSize: 48,
        color: const Color.fromRGBO(255, 255, 255, 1),
        onPressed: onBack,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
