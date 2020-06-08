import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/Themes/Theme.dart';
import 'package:iteraio/important.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:wiredash/wiredash.dart';

void main() {
  runApp(MyApp());
}

var appStarted = true;
bool noInternet = false;
bool serverTimeout = false;
Brightness brightness = Brightness.dark;

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
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
          toastLength: Toast.LENGTH_SHORT,
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
    });
    super.initState();
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 0));
  }

  _getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    themeStr = prefs.getString('theme');
    setState(() {
      getTheme(themeStr);
    });
    regdNo = prefs.getString('regd');
    password = prefs.getString('password');
    brightness = prefs.getBool('isbright') != null && prefs.getBool('isbright')
        ? Brightness.light
        : Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Wiredash(
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
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'ITER-AIO',
        // themeMode: ThemeMode.system,
        theme: ThemeData(
          primarySwatch: themeLight,
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: brightness,
          appBarTheme: AppBarTheme(color: themeDark),
        ),
        // darkTheme: ThemeData(
        //   primarySwatch: themeDark,
        //   // visualDensity: VisualDensity.adaptivePlatformDensity,
        //   brightness: Brightness.dark, //primaryColor: themeDark,
        //   appBarTheme: AppBarTheme(color: themeDark), indicatorColor: themeDark,
        //   // backgroundColor: Colors.black,
        //   hoverColor: themeDark,
        // ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          seconds: 1,
          //isLoading?sec:1,
          navigateAfterSeconds: new MyHomePage(),
          title: new Text(
            'ITER AIO\n\nAn all-in-one app for ITER',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.white70,
            ),
          ),
          backgroundColor: Colors.black87,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          image: Image.asset(
            'assets/logos/codex.jpg',
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
          loaderColor: Colors.white,
          // loadingText: Text(
          //   'LOADING...',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontSize: 16, color: Colors.white60),
          // ),
        ),
      ),
    );
  }
}

class Flare extends StatefulWidget {
  @override
  _FlareState createState() => _FlareState();
}

class _FlareState extends State<Flare> {
  @override
  Widget build(BuildContext context) {
    return new FlareActor("assets/animations/ITER-AIO.flr",
        alignment: Alignment.center, fit: BoxFit.contain, animation: "entry");
  }
}
