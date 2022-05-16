import 'package:ea_frontend/models/register.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/routes/auth_service.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../localization/language_constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool isLoading = false;
  bool isChecked = false;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  String birthDate = "";
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

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
                children: [
                  const SizedBox(height: 50),
                  Image.asset("public/logo.png"),
                  Text(
                    getTranslated(context, 'register')!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(247, 151, 28, 1), width: 2.0),
                        ),
                        hintText: getTranslated(context, 'name')!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(247, 151, 28, 1), width: 2.0),
                        ),
                        hintText: getTranslated(context, 'username')!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: DateTimePicker(
                      type: DateTimePickerType.date,
                      dateMask: 'dd/MM/yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      icon: const Icon(Icons.event),
                      dateLabelText: getTranslated(context, 'birthDate')!,
                      onSaved: (val) => birthDate = val!,
                      onChanged: (val) => birthDate = val,
                      onFieldSubmitted: (val) => birthDate = val,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextField(
                      controller: mailController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(247, 151, 28, 1), width: 2.0),
                        ),
                        hintText: getTranslated(context, 'mail')!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(247, 151, 28, 1), width: 2.0),
                        ),
                        hintText: getTranslated(context, 'password')!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                      child: TextField(
                      controller: repeatPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(247, 151, 28, 1), width: 2.0),
                        ),
                        hintText: getTranslated(context, 'repeatPassword')!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.black,
                        activeColor: Colors.orange,
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(
                        getTranslated(context, 'termsAndConditions')!,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 60)),
                      ),
                      child: Text(
                        getTranslated(context, 'submit')!,
                        style:
                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if(passwordController.text != repeatPasswordController.text) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(getTranslated(context, 'passwordError')!),
                              );
                            },
                          );
                        }
                        else if(!isChecked) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(getTranslated(context, 'termsError')!),
                              );
                            },
                          );
                        }
                        else {
                          setState(() {
                            isLoading = true;
                          });
                          var response = await authService.register(RegisterModel(
                              username: usernameController.text,
                              password: passwordController.text, 
                              birthDate: DateTime.parse(birthDate), 
                              mail: mailController.text, 
                              name: nameController.text)
                          );
                          setState(() {
                            isLoading = false;
                          });
                          if (response == "201") {
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
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated(context, 'alreadyWithAccount')!,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        child: Text(
                          getTranslated(context, 'signIn')!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        }
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
