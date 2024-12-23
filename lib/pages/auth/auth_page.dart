import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/libs/constants.dart';
import 'package:todo_app/libs/shared_preferences.dart';
import 'package:todo_app/pages/auth/widgets/custom_app_bar.dart';
import 'package:todo_app/pages/auth/widgets/submit_button.dart';
import 'package:todo_app/pages/auth/widgets/toggle_login_register.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/widgets/custom_text_field.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isFormValid = false;
  bool _loading = false;
  bool _isPasswordVisible = false;
  bool _login = true;

  void _validateForm() {
    setState(() {
      if (_login) {
        _isFormValid = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
      } else {
        _isFormValid = _emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty &&
            _usernameController.text.isNotEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider.notifier);
    final sharedPref = ref.read(sharedPreferencesProvider);
    final authState = ref.read(authServiceProvider.notifier);

    return Scaffold(
      backgroundColor: Constants.bgColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        onBack: () {
          sharedPref.setBool('showInfos', true);
          authState.setShowInfos(true);
          context.go('/infos');
        },
      ),
      body: Form(
        key: _formKey,
        onChanged: _validateForm,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: Constants.appPaddingX),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                _login ? 'Login' : 'Register',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              if (!_login)
                CustomTextField(
                  label: "Username",
                  controller: _usernameController,
                  hintText: "Enter your Username",
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your username';
                    return null;
                  },
                ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "Email",
                controller: _emailController,
                hintText: "Enter your Email",
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!regex.hasMatch(value)) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "Password",
                controller: _passwordController,
                hintText: "Enter your Password",
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your password';
                  if (value.length < 6) return 'Password must be at least 6 characters long';
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF535353),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 69),
              SubmitButton(
                isLoading: _loading,
                isFormValid: _isFormValid,
                onPressed: () async {
                  if (!_isFormValid || _loading) return;
                  try {
                    setState(() {
                      _loading = true;
                    });
                    if (_login) {
                      await authService.signInWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                      );
                    } else {
                      await authService.registerWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                      );

                      await authService.updateUserProfile(_usernameController.text);
                    }
                  } catch (e) {
                    if (!context.mounted) return;

                    final error = e.toString().replaceAll(RegExp(r'\[.*\]'), '');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );
                  } finally {
                    setState(() {
                      _loading = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ToggleLoginRegister(
                isLogin: _login,
                onToggle: () {
                  setState(() {
                    _login = !_login;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
