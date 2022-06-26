import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/login.dart';
import 'package:ea_frontend/routes/auth_service.dart';
import 'package:ea_frontend/routes/google_service.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:ea_frontend/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool darkTheme = false;

  Future<void> getThemeMode() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      darkTheme = _pref.getBool("theme")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    final LocalStorage storage = LocalStorage('BookHub');
    GoogleService googleService = GoogleService();

    return FutureBuilder(
        future: getThemeMode(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            body: Center(
              child: ListView(
                children: [
                  isLoading
                      ? LinearProgressIndicator(
                          color: Theme.of(context).backgroundColor,
                        )
                      : const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.25, vertical: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        darkTheme
                            ? Image.asset("public/logowhite.png")
                            : Image.asset("public/logo.png"),
                        Text(
                          getTranslated(context, 'signIn')!,
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).backgroundColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).backgroundColor,
                                    width: 3.0),
                              ),
                              hintText: getTranslated(context, 'username')!,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).backgroundColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).backgroundColor,
                                    width: 3.0),
                              ),
                              hintText: getTranslated(context, 'password')!,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).backgroundColor),
                              minimumSize: MaterialStateProperty.all(
                                  Size(MediaQuery.of(context).size.width, 60)),
                            ),
                            child: Text(
                              getTranslated(context, 'submit')!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                storage.setItem('userName',
                                    usernameController.text.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        maintainState: false,
                                        builder: (context) =>
                                            const HomeScaffold()));
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
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getTranslated(context, 'stillWithoutAccount')!,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              child: Text(
                                getTranslated(context, 'register')!,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        maintainState: false,
                                        builder: (context) =>
                                            const RegisterPage()));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MediaQuery.of(context).size.width >= 1100
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 320),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                60)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 30.0,
                                            width: 30.0,
                                            child: Image.asset(
                                                "public/google.png"),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            getTranslated(
                                                context, 'loginGoogle')!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        await googleService.signIn(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 320),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                60)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 30.0,
                                            width: 30.0,
                                            child: Image.asset(
                                                "public/google.png"),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            getTranslated(
                                                context, 'registerGoogle')!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        await googleService.signUp(context);
                                      },
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 320),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                60)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 30.0,
                                            width: 30.0,
                                            child: Image.asset(
                                                "public/google.png"),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            getTranslated(
                                                context, 'loginGoogle')!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        await googleService.signIn(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 320),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                60)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 30.0,
                                            width: 30.0,
                                            child: Image.asset(
                                                "public/google.png"),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            getTranslated(
                                                context, 'registerGoogle')!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        await googleService.signUp(context);
                                      },
                                    ),
                                  )
                                ],
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
