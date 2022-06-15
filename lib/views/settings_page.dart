import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/views/login_page.dart';
import 'package:ea_frontend/views/settings/account_page.dart';
import 'package:ea_frontend/views/widgets/edit_profile.dart';
import 'package:ea_frontend/views/widgets/icon_widget.dart';
import 'package:ea_frontend/views/widgets/change_theme_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:localstorage/localstorage.dart';

import '../models/report.dart';
import '../models/user.dart';
import '../routes/report_service.dart';
import '../routes/user_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Report> reportList = List.empty(growable: true);
  bool _noreports = true;
  String userid = "";
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final typeController = TextEditingController(text: "");

  void initState() {
    super.initState();
    fetchUser();
    getReportsList();
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;
    userid = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(userid);
  }

  Future<void> getReportsList() async {
    storage = LocalStorage('BookHub');
    await storage.ready;
    userid = LocalStorage('BookHub').getItem('userId');
    reportList = (await ReportService.getReportByUser(userid)).cast<Report>();
    setState(() {
      if (reportList.length != 0) {
        _noreports = false;
      }
    });
  }

  TextEditingController controllerOld = TextEditingController(text: '');
  TextEditingController controllerNew = TextEditingController(text: '');
  TextEditingController controllerCheck = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
              child: ListView(padding: EdgeInsets.all(24), children: [
        Text(
          getTranslated(context, 'settings')!,
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        SettingsGroup(
          title: getTranslated(context, 'general')!,
          children: <Widget>[
            buildAccountTheme(context),
            AccountPage(),
            buildEditProfile(),
            buildLogout(),
            buildPassword(),
            buildDeleteAccount(),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              getTranslated(context, 'reports')!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 150.0,
                child: _noreports
                    ? Column(
                        children: [
                          Text(getTranslated(context, 'noReports')!),
                        ],
                      )
                    : ListView.builder(
                        itemCount: reportList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ReportItem(
                            reportList[index].user,
                            reportList[index].title,
                            reportList[index].text,
                            reportList[index].type,
                            index,
                          );
                        }),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              getTranslated(context, 'addReport')!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: titleController,
              validator: (value) {
                if (value!.isEmpty) {
                  return getTranslated(context, "fieldRequired");
                }
                return null;
              },
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  labelText: getTranslated(context, "title")!,
                  hintText: getTranslated(context, "writeTheTitle"),
                  border: OutlineInputBorder()),
            )),
        const SizedBox(
          height: 10,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: textController,
              maxLines: 4,
              maxLength: 400,
              validator: (value) {
                if (value!.isEmpty) {
                  return getTranslated(context, "fieldRequired");
                }
                return null;
              },
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  labelText: getTranslated(context, "text")!,
                  hintText: getTranslated(context, "writeTheText"),
                  border: OutlineInputBorder()),
            )),
        const SizedBox(height: 10),
        Container(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              getTranslated(context, 'UserReportInfo')!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: typeController,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  labelText: getTranslated(context, "userReport")!,
                  hintText: getTranslated(context, "writeTheUserReport"),
                  border: OutlineInputBorder()),
            )),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          child: Text(
            getTranslated(context, "addNewReport")!,
            textScaleFactor: 1,
          ),
          onPressed: () async {
            print("Add new report");
            String idReport = "";
            if (typeController.text != "") {
              User userReport =
                  await UserService.getUserByUserName(typeController.text);
              idReport = userReport.id;
            }
            var response = await ReportService.addReport(Report(
                user: userid,
                title: titleController.text,
                type: idReport,
                text: textController.text));
            if (response == "200") {
              print("New report added");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
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
          style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        )
      ])));

  Widget buildEditProfile() => SimpleSettingsTile(
        title: "View Profile",
        subtitle: '',
        leading: const IconWidget(icon: Icons.face, color: Colors.orange),
        child: EditProfile(),
      );
  Widget buildLogout() => SimpleSettingsTile(
      title: getTranslated(context, 'logout')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.logout, color: Colors.blueAccent),
      onTap: () => {
            LocalStorage('BookHub').deleteItem('token'),
            Navigator.pop(context),
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
          });

  Widget buildPassword() => SimpleSettingsTile(
      title: "Change password",
      subtitle: '',
      leading: const IconWidget(icon: Icons.lock, color: Colors.purpleAccent),
      onTap: () => {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Change Password",
                            style: TextStyle(fontSize: 20),
                          ),
                          buildEdit("Old password", controllerOld),
                          buildEdit("New password", controllerNew),
                          buildEdit("Repeat password", controllerCheck),
                          ElevatedButton(
                              onPressed: () {
                                if (controllerOld.text.isEmpty &&
                                    controllerNew.text.isEmpty &&
                                    controllerCheck.text.isEmpty) {
                                  print("algun campo vacio");
                                } else {
                                  if (controllerCheck.text ==
                                      controllerNew.text) {
                                    UserService.changePassword(
                                        LocalStorage('BookHub')
                                            .getItem('userId'),
                                        controllerNew.text,
                                        controllerOld.text);
                                    Navigator.of(context).pop();
                                  } else {
                                    print("print psw no coincideixen");
                                  }
                                }
                              },
                              child: Text("Change"))
                        ],
                      ),
                    ),
                  );
                })
          });
  Widget buildEdit(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TextField(
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            hintText: labelText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            )),
      ),
    );
  }

  Widget buildDeleteAccount() => SimpleSettingsTile(
      title: getTranslated(context, 'deleteAccount')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.delete, color: Colors.pink),
      onTap: () async => {
            await UserService.deleteAccount(
                LocalStorage('BookHub').getItem('userId') as String),
            LocalStorage('BookHub').deleteItem('token'),
            Navigator.pop(context),
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
          });

  Widget buildAccountTheme(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Tema: "),
          const Spacer(),
          ChangeThemeButtonWidget(),
        ],
      );

  Widget ReportItem(
      dynamic user, String title, String text, String type, int index) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.warning,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(text),
    );
  }
}
