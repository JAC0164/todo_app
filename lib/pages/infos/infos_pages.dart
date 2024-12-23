import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/libs/shared_preferences.dart';
import 'package:todo_app/pages/infos/widgets/custom_app_bar.dart';
import 'package:todo_app/pages/infos/widgets/navigation_buttons.dart';
import 'package:todo_app/pages/infos/widgets/step_content.dart';
import 'package:todo_app/pages/infos/widgets/step_image.dart';
import 'package:todo_app/pages/infos/widgets/step_indicator.dart';
import 'package:todo_app/services/auth_service.dart';

class InfosPages extends ConsumerStatefulWidget {
  const InfosPages({super.key});

  @override
  ConsumerState<InfosPages> createState() => _InfosPagesState();
}

class _InfosPagesState extends ConsumerState<InfosPages> {
  int _step = 0;
  final int _totalSteps = 3;
  final List<String> _titles = [
    'Manage your tasks',
    'Create daily routine',
    'Organize your tasks',
  ];
  final List<String> _descriptions = [
    'You can easily manage all of your daily tasks in DoMe for free',
    'In Uptodo you can create your personalized routine to stay productive',
    'You can organize your daily tasks by adding your tasks into separate categories',
  ];
  bool _isForward = true;

  void _nextStep() {
    if (_step < _titles.length - 1) {
      setState(() {
        _isForward = true; // Moving forward
        _step++;
      });
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() {
        _isForward = false; // Moving backward
        _step--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider.notifier);
    final sharedPref = ref.read(sharedPreferencesProvider);

    return Scaffold(
      backgroundColor: Constants.bgColor,
      appBar: CustomAppBar(
        onSkip: () {
          sharedPref.setBool('showInfos', false);
          authService.setShowInfos(false);
          context.go('/auth');
        },
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: Constants.appPaddingX),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StepImage(step: _step, isForward: _isForward),
            const SizedBox(height: 50),
            StepIndicator(currentStep: _step, totalSteps: _totalSteps),
            const SizedBox(height: 50),
            StepContent(
              title: _titles[_step],
              description: _descriptions[_step],
            ),
            const Spacer(),
            NavigationButtons(
              step: _step,
              totalSteps: _totalSteps,
              onBack: _prevStep,
              onNext: () {
                if (_step < _totalSteps - 1) {
                  _nextStep();
                } else {
                  sharedPref.setBool('showInfos', false);
                  authService.setShowInfos(false);
                  context.go('/auth');
                }
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
