import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/Themes/Theme.dart';
import 'package:iteraio/important.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';
import 'package:package_info/package_info.dart';

import 'package:overlay_support/overlay_support.dart';

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
var updateText = "New Update is Here!";

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
      fetchupdate(context);
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
      ),
    );
  }

  fetchupdate(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    final Response response =
        await get('https://github.com/KejariwalAyush/ITER-AIO/releases/latest');
    if (response.statusCode == 200) {
      var document = parse(response.body);
      updateText = document.querySelector('div.markdown-body').text;
      print(updateText);
      List links = document.querySelectorAll('div > ul > li > a > span ');
      List<Map<String, String>> linkMap = [];
      for (var link in links) {
        linkMap.add({
          'title': link.text,
        });
      }
      var dec = jsonDecode(json.encode(linkMap));
      latestversion = dec[6]['title'];

      List links2 = document.querySelectorAll('details > div > div > div > a');
      List<Map<String, String>> linkMap2 = [];
      for (var link in links2) {
        linkMap2.add({
          'title': 'https://github.com' + link.attributes['href'],
        });
      }
      var dec2 = jsonDecode(json.encode(linkMap2));
      updatelink = dec2[0]['title'];
      print(updatelink);

      if (version.compareTo(latestversion) != 0) {
        print('update available');
        isUpdateAvailable = true;
        showSimpleNotification(
          Text(
            "Update available version: $latestversion",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.black,
          autoDismiss: false,
          leading: Icon(
            Icons.upgrade_rounded,
            color: Colors.white,
          ),
          slideDismiss: true,
          position: NotificationPosition.bottom,
          trailing: Builder(builder: (context) {
            return FlatButton(
                textColor: Colors.yellow,
                onPressed: () => {
                      _launchURL(updatelink),
                    },
                child: Text('UPDATE'));
          }),
        );
        // Alert is in the getData fuction in homePage
      } else {
        print('Up-to-Date');
        isUpdateAvailable = false;
      }
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return;
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
        'assets/logos/codexLogo.png',
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
