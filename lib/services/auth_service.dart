import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/models/auth_data.dart';

final authServiceProvider = StateNotifierProvider<AuthService, AuthData>((ref) {
  return AuthService();
});

class AuthService extends StateNotifier<AuthData> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService() : super(AuthData(user: null));

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (_) {
      return Future.error('Invalid email or password');
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (_) {
      return Future.error('Invalid email or password');
    }
  }

  // Register with google
  Future<UserCredential> registerWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
      return userCredential;
    } on FirebaseAuthException catch (_) {
      return Future.error('Failed to sign in with Google');
    }
  }

  Future<void> updateUserProfile(String displayName) async {
    try {
      await _auth.currentUser!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (_) {
      return Future.error('Failed to update user profile');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update the state
  void setUser(User? user) {
    state = AuthData(user: user, loading: state.loading, showInfos: state.showInfos);
  }

  void setShowInfos(bool showInfos) {
    state = AuthData(user: state.user, loading: state.loading, showInfos: showInfos);
  }

  void setLoading(bool loading) {
    state = AuthData(user: state.user, loading: loading, showInfos: state.showInfos);
  }
}
