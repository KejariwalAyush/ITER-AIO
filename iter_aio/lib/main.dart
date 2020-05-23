import 'package:flutter/material.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/Themes/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

var appStarted = true;

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setState(() {
      _getCredentials();
    });
    super.initState();
  }

  _getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    regdNo = prefs.getString('regd');
    password = prefs.getString('password');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ITER-AIO',
        themeMode: ThemeMode.system,
        theme: ThemeData(
            primarySwatch: themeLight,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            brightness: Brightness.light),
        darkTheme: ThemeData(
          primarySwatch: themeDark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark, //primaryColor: themeDark,
          appBarTheme: AppBarTheme(color: themeDark), indicatorColor: themeDark,
          hoverColor: themeDark,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          seconds: 1,
          //isLoading?sec:1,
          navigateAfterSeconds: MyHomePage(),
          title: new Text(
            'ITER AIO\n\nAn all-in-one app for ITER',
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.white70,
            ),
          ),
          backgroundColor: themeDark,
          styleTextUnderTheLoader: new TextStyle(),
          // photoSize: 180.0,
          loaderColor: Colors.white,
          loadingText: Text(
            'LOADING...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ));
  }
}
