import 'package:flutter/material.dart';
import 'package:todo_app/libs/constants.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  @override
  void initState() {
    super.initState();

    getUsageStats();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constants.appPaddingX),
      child: const Column(
        children: [],
      ),
    );
  }

  void getUsageStats() async {}
}
