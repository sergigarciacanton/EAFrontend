import 'package:ea_frontend/views/settings/account_page.dart';
import 'package:ea_frontend/views/widgets/icon_widget.dart';
import 'package:ea_frontend/views/widgets/change_theme_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:ea_frontend/localization/language_constants.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
            buildLogout(),
            buildDeleteAccount(),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        SettingsGroup(
            title: getTranslated(context, 'feedback')!,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              buildReportBug(context),
              buildSendFeedback(context),
            ])
      ])));

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

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
      title: getTranslated(context, 'reportABug')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.bug_report, color: Colors.teal),
      onTap: () => {});

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
      title: getTranslated(context, 'sendFeedback')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.thumb_up, color: Colors.purple),
      onTap: () => {});

  Widget buildAccountTheme(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text("Tema: "), const Spacer(), ChangeThemeButtonWidget()],
      );
}
