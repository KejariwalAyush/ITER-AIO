import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/Themes/Theme.dart';
import 'package:iteraio/important.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:wiredash/wiredash.dart';
import 'package:package_info/package_info.dart';

void main() {
  runApp(MyApp());
}

var appStarted = true;
bool noInternet = false;
bool serverTimeout = false;
Brightness brightness = Brightness.dark;

String appName = 'ITER-AIO';
String packageName;
String version = '1.0';
String buildNumber;
String updatelink;
String latestversion;
bool isUpdateAvailable = false;

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
        debugShowCheckedModeBanner: false,
        home: PushMessagingExample(),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
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
      loadingText: Text(
        'LOADING...',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white60),
      ),
    );
  }
}

class PushMessagingExample extends StatefulWidget {
  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();
}

class _PushMessagingExampleState extends State<PushMessagingExample> {
  String _homeScreenText = "Waiting for token...";
  // String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onResume: $message");
      },
    );
    //  _firebaseMessaging.requestNotificationPermissions(
    //      const IosNotificationSettings(sound: true, badge: true, alert: true));
    //  _firebaseMessaging.onIosSettingsRegistered
    //      .listen((IosNotificationSettings settings) {
    //    print("Settings registered: $settings");
    //  });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Splash();
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
