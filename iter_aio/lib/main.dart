import 'dart:io' show InternetAddress, Platform, SocketException;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/push_msg.dart';
import 'package:iteraio/components/splash_screen.dart';
import 'package:iteraio/helper/attendance_fetch.dart';
import 'package:iteraio/helper/login_fetch.dart';
import 'package:iteraio/helper/notices_fetch.dart';
import 'package:iteraio/helper/profile_fetch.dart';
import 'package:iteraio/helper/result_fetch.dart';
import 'package:iteraio/helper/update_fetch.dart';
import 'package:iteraio/important.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/pages/sides/aboutus_page.dart';
import 'package:iteraio/pages/attendance_page.dart';
import 'package:iteraio/pages/sides/courses_page.dart';
import 'package:iteraio/pages/login_page.dart';
import 'package:iteraio/pages/notices.dart';
import 'package:iteraio/pages/sides/planBunk.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/pages/sides/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';
import 'package:package_info/package_info.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/helper/lectures_fetch.dart';
import 'package:iteraio/pages/clubs/clubs_page.dart';
import 'package:iteraio/landing/landingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isMobile = kIsWeb || Platform.isWindows || Platform.isWindows ? false : true;
  if (Platform.isAndroid || Platform.isIOS) await Firebase.initializeApp();
  kIsWeb ? runApp(MyApp()) : runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth auth = !isMobile ? null : FirebaseAuth.instance;
  FirebaseFirestore firestore = !isMobile ? null : FirebaseFirestore.instance;
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    if (isMobile)
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          firebaseSignedIn = false;
          print('User is currently signed out!');
        } else {
          firebaseSignedIn = true;
          googleUser = user;
          print('User is signed in!');
        }
      });
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
        if (isMobile)
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
      isUpdateAvailable = await UpdateFetch().fetchupdate(context);
    });
    setState(() {
      nf = NoticesFetch();
      _getCredentials();
    });

    isMobile =
        kIsWeb || Platform.isWindows || Platform.isWindows ? false : true;
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future _getThingsOnStartup() async {
    UpdateFetch().fetchupdate(context);
    clubsName = await clubs.get().then((QuerySnapshot querySnapshot) {
      List<String> _list = [];
      querySnapshot.docs.forEach((doc) {
        _list.add(doc['name']);
      });
      return _list;
    });
    clubsDoc = await clubs.get().then((QuerySnapshot querySnapshot) {
      List<String> _list = [];
      querySnapshot.docs.forEach((doc) {
        _list.add(doc.id);
      });
      return _list;
    });
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
    isLoggedIn = prefs.getBool('isLoggedIn');
    sem = prefs.getInt('sem');
    regdNo = prefs.getString('regd');
    password = prefs.getString('password');
    brightness = prefs.getBool('isbright') != null && prefs.getBool('isbright')
        ? Brightness.light
        : Brightness.dark;
    _login(regdNo, password);
  }

  @override
  Widget build(BuildContext context) {
    /*if (!kIsWeb)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);*/
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
        '${MyHomePage.routeName}': (context) => MyHomePage(),
        '${LoginPage.routeName}': (context) => LoginPage(),
        '${AttendancePage.routeName}': (context) => AttendancePage(),
        '${CoursesPage.routeName}': (context) => CoursesPage(),
        '${ResultPage.routeName}': (context) => ResultPage(),
        '${Notices.routeName}': (context) => Notices(),
        '${PlanBunk.routeName}': (context) => PlanBunk(),
        '${AboutUs.routeName}': (context) => AboutUs(),
        '${SettingsPage.routeName}': (context) => SettingsPage(),
        '${ClubsPage.routeName}': (context) => ClubsPage(),
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

  // ignore: missing_return
  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return LoginPage();
    }));
  }

  _login(String _regdNo, String _password) async {
    // setState(() {
    //   isLoading = true;
    // });
    loginFetch = LoginFetch(regdNo: _regdNo, password: _password);
    LoginData ld = await loginFetch.getLogin();
    if (ld.status == "success")
      setState(() {
        // _setCredentials();
        // _setCredentials();
        // _isLoggingIn = true;
        isLoggedIn = true;
        cookie = ld.cookie;
        af = AttendanceFetch();
        rf = ResultFetch();
        pi = ProfileFetch();
        lf = LecturesFetch(semNo: sem);
      });
  }
}
