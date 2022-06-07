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
  final typeController = TextEditingController();

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
              String idReport = userReport.id;
            } else {}
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
