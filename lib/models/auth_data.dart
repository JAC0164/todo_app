import 'package:firebase_auth/firebase_auth.dart';

class AuthData {
  final User? user;
  bool loading = true;
  bool showInfos = true;

  AuthData({this.user, this.loading = true, this.showInfos = true});
}
