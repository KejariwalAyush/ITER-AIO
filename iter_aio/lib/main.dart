import 'dart:io' show InternetAddress, Platform, SocketException;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/push_msg.dart';
import 'package:iteraio/components/splash_screen.dart';
import 'package:iteraio/helper/update_fetch.dart';
import 'package:iteraio/important.dart';
import 'package:iteraio/pages/aboutus_page.dart';
import 'package:iteraio/pages/attendance_page.dart';
import 'package:iteraio/pages/courses_page.dart';
import 'package:iteraio/pages/login_page.dart';
import 'package:iteraio/pages/notices.dart';
import 'package:iteraio/pages/planBunk.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';
import 'package:package_info/package_info.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  kIsWeb ? runApp(MyApp()) : runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  // ignore: unused_field
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging();

  @override
  void initState() {
    fiam.setAutomaticDataCollectionEnabled(true);
    _getThingsOnStartup().then((value) async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
        }
      } on SocketException catch (_) {
        print('not connected');
        noInternet = true;
        Fluttertoast.showToast(
          msg: "No INTERNET !\nOffline Mode activated",
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
    setState(() {
      _getCredentials();
      UpdateFetch().fetchupdate(context);
    });

    isMobile =
        kIsWeb || Platform.isWindows || Platform.isWindows ? false : true;
    super.initState();
  }

  Future _getThingsOnStartup() async {
    UpdateFetch().fetchupdate(context);
    // await Future.delayed(Duration(seconds: 0));
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  _getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    themeStr = prefs.getString('theme');
    setState(() {
      getTheme(themeStr);
    });
    sem = prefs.getInt('sem');
    regdNo = prefs.getString('regd');
    password = prefs.getString('password');
    brightness = prefs.getBool('isbright') != null && prefs.getBool('isbright')
        ? Brightness.light
        : Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    if (kIsWeb)
      return OverlaySupport(child: buildMaterialWebApp());
    else if (Platform.isAndroid || Platform.isIOS)
      return OverlaySupport(
        child: Wiredash(
          projectId: wiredash_project_id,
          secret: wiredash_api_secret,
          navigatorKey: _navigatorKey,
          options: WiredashOptionsData(
            showDebugFloatingEntryPoint: false,
          ),
          theme: WiredashThemeData(
            brightness: brightness,
            primaryColor: themeDark,
            secondaryColor: themeDark,
            backgroundColor: colorDark,
            //primaryBackgroundColor: colorDark
          ),
          child: buildMaterialApp(),
        ),
      );
    else if (Platform.isWindows || Platform.isFuchsia || Platform.isMacOS)
      return buildMaterialApp();
    else
      return OverlaySupport(child: buildMaterialApp());
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'ITER-AIO',
      initialRoute: '/',
      routes: {
        '/': (context) => PushMessagingExample(),
        '${LoginPage.routeName}': (context) => LoginPage(),
        '${AttendancePage.routeName}': (context) => AttendancePage(),
        '${CoursesPage.routeName}': (context) => CoursesPage(),
        '${ResultPage.routeName}': (context) => ResultPage(),
        '${Notices.routeName}': (context) => Notices(),
        '${PlanBunk.routeName}': (context) => PlanBunk(),
        '${AboutUs.routeName}': (context) => AboutUs(),
        '${SettingsPage.routeName}': (context) => SettingsPage(),
      },
      // themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: themeLight,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: brightness,
        appBarTheme: AppBarTheme(color: themeDark),
      ),
      debugShowCheckedModeBanner: false,
      // home: PushMessagingExample(),
    );
  }

  MaterialApp buildMaterialWebApp() {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'ITER-AIO',
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '${LoginPage.routeName}': (context) => LoginPage(),
        '${AttendancePage.routeName}': (context) => AttendancePage(),
        '${CoursesPage.routeName}': (context) => CoursesPage(),
        '${ResultPage.routeName}': (context) => ResultPage(),
        '${Notices.routeName}': (context) => Notices(),
        '${PlanBunk.routeName}': (context) => PlanBunk(),
        '${AboutUs.routeName}': (context) => AboutUs(),
        '${SettingsPage.routeName}': (context) => SettingsPage(),
      },
      // themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: themeLight,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: brightness,
        appBarTheme: AppBarTheme(color: themeDark),
      ),
      debugShowCheckedModeBanner: false,
      // home: PushMessagingExample(),
    );
  }
}
