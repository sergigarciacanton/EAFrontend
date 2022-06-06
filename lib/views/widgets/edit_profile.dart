import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/views/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:email_validator/email_validator.dart';

import '../../localization/language_constants.dart';
import '../settings_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String idUser;
  var storage;
  var isEditing = false;

  TextEditingController controllerName = TextEditingController(text: 'Name');
  TextEditingController controllerUserName =
      TextEditingController(text: 'userName');
  TextEditingController controllerMail = TextEditingController(text: 'mail');
  String controllerBirthDay = "";

  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idUser = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(idUser);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            controllerName.text = snapshot.data!.name;
            controllerUserName.text = snapshot.data!.userName;
            controllerMail.text = snapshot.data!.mail;
            controllerBirthDay = snapshot.data!.birthDate.toString();
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 1,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => const SettingPage());
                    Navigator.pop(context, route);
                  },
                ),
              ),
              body: Container(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                child: ListView(
                  children: [
                    Text(
                      "Edit Profile",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).shadowColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                    ))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).shadowColor,
                                ),
                                color: Colors.green,
                              ),
                              child: InkWell(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    print("change photo");
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    buildData(snapshot),
                    SizedBox(
                      height: 35,
                    ),
                    (isEditing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                child: Text("CANCEL",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (controllerName.value.text.isNotEmpty &&
                                      controllerUserName
                                          .value.text.isNotEmpty &&
                                      EmailValidator.validate(
                                          controllerMail.value.text)) {
                                    var response = await UserService.updateUser(
                                        idUser,
                                        controllerName.text,
                                        controllerUserName.text,
                                        controllerMail.text,
                                        controllerBirthDay);
                                    if (response) {
                                      setState(() {
                                        isEditing = false;
                                      });
                                    }
                                  } else {
                                    String error = "Se ha producido un error";
                                    controllerName.text.isEmpty
                                        ? error = "Name empty"
                                        : null;
                                    controllerUserName.text.isEmpty
                                        ? error = "userName empty"
                                        : null;
                                    !EmailValidator.validate(
                                            controllerMail.text)
                                        ? error = "Invalid email"
                                        : null;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(error),
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                ),
                                child: Text(
                                  "SAVE",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          )
                        : Container()),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            print(snapshot.error);
            //   throw snapshot.error.hashCode;
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }

  Widget buildData(AsyncSnapshot<User> snapshot) {
    return Column(
      children: [
        buildEdit("Full Name", controllerName),
        buildEdit("User Name", controllerUserName),
        buildEdit("E-mail", controllerMail),
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: DateTimePicker(
            type: DateTimePickerType.date,
            dateMask: 'dd/MM/yyyy',
            initialValue: snapshot.data!.birthDate.toString(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            icon: const Icon(Icons.event),
            dateLabelText: "birthDate",
            onSaved: (val) => controllerBirthDay = val!,
            onChanged: (val) => controllerBirthDay = val,
            onFieldSubmitted: (val) => controllerBirthDay = val,
          ),
        )
      ],
    );
  }

  Widget buildEdit(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        onTap: () {
          (!isEditing)
              ? setState(() {
                  isEditing = true;
                })
              : null;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: labelText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            )),
      ),
    );
  }
}
