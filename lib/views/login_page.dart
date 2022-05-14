import 'dart:async';
import 'dart:developer';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/login.dart';
import 'package:ea_frontend/routes/auth_service.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:ea_frontend/views/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void checkToken() async {
    var token = LocalStorage('BookHub').getItem('token');
    if (token == null) {
      return;
    }
    var response = await AuthService.verifyToken(token);
    if (response == '200') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HomeScaffold()));
    } else {
      log(response.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var storage = LocalStorage('BookHub');
    storage.ready.then(((value) => checkToken()));

    //AuthService.verifyToken(token);
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ListView(
          children: [
            isLoading
                ? const LinearProgressIndicator()
                : const SizedBox(height: 0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.25, vertical: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(height: 50),
                  Image.asset("public/logo.png"),
                  Text(
                    //TODO poner esta cosa en todos los sitios que quieras traducir
                    getTranslated(context, 'signIn')!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(247, 151, 28, 1), width: 2.0),
                      ),
                      hintText: getTranslated(context, 'username')!,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(247, 151, 28, 1), width: 2.0),
                      ),
                      hintText: getTranslated(context, 'password')!,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 60)),
                    ),
                    child: Text(
                      getTranslated(context, 'submit')!,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      var response = await authService.login(LoginModel(
                          username: usernameController.text,
                          password: passwordController.text));
                      setState(() {
                        isLoading = false;
                      });
                      if (response == "200") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
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
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated(context, 'stillWithoutAccount')!,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        child: Text(
                          getTranslated(context, 'register')!,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
