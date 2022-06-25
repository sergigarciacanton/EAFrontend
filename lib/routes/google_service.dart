import 'package:ea_frontend/models/login.dart';
import 'package:ea_frontend/models/register.dart';
import 'package:ea_frontend/routes/auth_service.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:ea_frontend/views/questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localstorage/localstorage.dart';

class GoogleService {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "63306907101-ckjrt077cpejr5kh0cpa0ulusasi7m2t.apps.googleusercontent.com",
  );
  final LocalStorage storage = LocalStorage('BookHub');
  AuthService authService = AuthService();

  Future<void> signIn(BuildContext context) async {
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account?.displayName != null) {
      var response = await authService
          .login(LoginModel(username: account!.displayName ?? ""));
      if (response == "200") {
        storage.setItem('userName', account.displayName);
        Navigator.push(
            context,
            MaterialPageRoute(
                maintainState: false,
                builder: (context) => const HomeScaffold()));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(response.toString()),
            );
          },
        );
      }
    }
  }

  Future<void> signUp(BuildContext context) async {
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account?.displayName != null) {
      String response = await authService.register(RegisterModel(
        username: account!.displayName ?? "",
        birthDate: DateTime.now(),
        mail: account.email,
        name: account.displayName ?? "",
        google: true,
      ));
      if (response == "201") {
        storage.setItem('userName', account.displayName);
        Navigator.push(
            context,
            MaterialPageRoute(
                maintainState: false,
                builder: (context) => const Questionnaire()));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(response.toString()),
            );
          },
        );
      }
    }
  }
}
