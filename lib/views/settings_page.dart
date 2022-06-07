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
  String userid = "";
  final titleController = TextEditingController();
  final textController = TextEditingController();

  void initState() {
    super.initState();
    fetchUser();
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;
    userid = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(userid);
  }

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
            buildDeleteAccount(),
          ],
        ),
        const SizedBox(
          height: 32,
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
              maxLength: 300,
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
            var response = await ReportService.addReport(Report(
                user: userid,
                title: titleController.text,
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
      onTap: () => {});

  Widget buildDeleteAccount() => SimpleSettingsTile(
      title: getTranslated(context, 'deleteAccount')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.delete, color: Colors.pink),
      onTap: () => {});

  Widget buildAccountTheme(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Tema: "),
          const Spacer(),
          ChangeThemeButtonWidget(),
        ],
      );
}
