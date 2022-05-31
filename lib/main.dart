import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:ea_frontend/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/demo_localization.dart';
import 'localization/language_constants.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ea_frontend/routes/auth_service.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ea_frontend/views/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp() : super();
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
    await dotenv.load(fileName: ".env");
    final cloudinary = Cloudinary.full(
        apiKey: dotenv.env['CLOUDINARY_API_KEY']!,
        apiSecret: dotenv.env['CLOUDINARY_API_SECRET']!,
        cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          // if (this._locale == null) {
          //   setLocale(Locale('es'));
          // }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "BookHub",
              themeMode: themeProvider.themeMode,
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              locale: _locale,
              supportedLocales: const [
                Locale("en", ""),
                Locale("es", ""),
                Locale("ca", ""),
              ],
              localizationsDelegates: const [
                DemoLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale!.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              home: AnimatedSplashScreen.withScreenFunction(
                  duration: 30,
                  splash: "public/logosplash.png",
                  splashIconSize: 500,
                  screenFunction: () async {
                    var storage = LocalStorage('BookHub');
                    await storage.ready;

                    var token = LocalStorage('BookHub').getItem('token');
                    if (token == null) {
                      return const LoginPage();
                    }
                    var response = await AuthService.verifyToken(token);
                    if (response == '200') {
                      log('Load home scaffold');
                      return const HomeScaffold();
                    }
                    return const LoginPage();
                  },
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.fade,
                  backgroundColor: Colors.blueGrey));
        },
      );
}
