import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/libs/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/libs/firebase_options.dart';
import 'package:todo_app/libs/shared_preferences.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Flutter Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider.notifier);
    final authState = ref.watch(authServiceProvider);
    final sharedPref = ref.read(sharedPreferencesProvider);
    final todoService = ref.read(todoServiceProvider.notifier);

    // Listen to changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      final showInfos = (await sharedPref.getBool('showInfos')) ?? true;

      // Update showInfos
      if (authState.showInfos != showInfos) authService.setShowInfos(showInfos);

      // Update user
      if (user != null && authState.user == null) {
        authService.setUser(user);

        // Get todos and categories
        todoService.getTodos(user.uid);
        todoService.getCategories(user.uid);
      } else if (user == null && user != null) {
        authService.setUser(null);
      }

      // Update loading
      if (authState.loading) authService.setLoading(false);
      FlutterNativeSplash.remove();
    });

    return MaterialApp.router(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: appRouter(authState),
    );
  }
}
