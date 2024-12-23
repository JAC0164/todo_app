import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/libs/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/libs/firebase_options.dart';
import 'package:todo_app/libs/shared_preferences.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/services/todo_service.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
