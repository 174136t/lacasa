import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lacasa/splash/splash.dart';
import 'package:lacasa/staff_dashboard/pointsDialog/enterCodedDalog.dart';
import 'package:scoped_model/scoped_model.dart';

import 'localization/app_localization.dart';

bool isarabic = false;

void main() {
  runApp(ScopeModelWrapper());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findRootAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Locale _locale;
  @override
  Widget build(BuildContext context) {
    WidgetsApp.debugAllowBannerOverride = false;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return MaterialApp(
          locale: _locale,
          localizationsDelegates: [
            // ... app-specific localization delegate[s] here
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', 'SA'),
          ],
          localeResolutionCallback:
              (Locale deviceLocale, Iterable<Locale> supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }

            return supportedLocales.first;
          },
          theme:ThemeData(
          primarySwatch: Colors.amber,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          )) ,
          debugShowCheckedModeBanner: false,
          home: Splash());
    });
  }
}

class ScopeModelWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(model: AppModel(), child: MyApp());
  }
}

class AppModel extends Model {
  Locale _appLocale = Locale('en');
  Locale get appLocal => _appLocale ?? Locale("en");

  void changeDirection() {
    if (_appLocale == Locale("ar")) {
      _appLocale = Locale("en");
    } else {
      _appLocale = Locale("ar");
    }
    notifyListeners();
  }
}
