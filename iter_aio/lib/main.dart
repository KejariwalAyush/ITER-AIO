import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/push_msg.dart';
import 'package:iteraio/important.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';
import 'package:package_info/package_info.dart';
// import 'package:iteraio/MyHomePage.dart';

import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

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
    // setState(() {
    //   isLoading = true;
    // });
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
      // print(updateText);
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
      // print(updatelink);

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
        // print('Up-to-Date');
        isUpdateAvailable = false;
      }
      // setState(() {
      //   isLoading = false;
      // });
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
