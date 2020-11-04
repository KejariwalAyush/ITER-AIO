import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/pages/notices.dart';
import 'package:iteraio/helper/attendance_fetch.dart';
import 'package:iteraio/helper/lectures_fetch.dart';
import 'package:iteraio/helper/login_fetch.dart';
import 'package:iteraio/helper/profile_fetch.dart';
import 'package:iteraio/helper/result_fetch.dart';
import 'package:iteraio/helper/update_fetch.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/pages/attendance_page.dart';
import 'package:iteraio/widgets/Mdviewer.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/widgets/on_pop.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login-page";
  final bool logout;

  LoginPage({Key key, this.logout = false}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggingIn = false;
  bool isLoading = false;
  String animationName = 'hello';
  bool showPassword = false;

  @override
  void initState() {
    if (isUpdateAvailable) UpdateFetch().showUpdateDialog(context);
    if (widget.logout) logout();
    _getCredentials();
    _login(regdNo, password);
    if (sem != null) lf = new LecturesFetch(semNo: sem);
    FetchNotice();
    super.initState();
  }

  _login(String _regdNo, String _password) async {
    setState(() {
      isLoading = true;
    });
    loginFetch = LoginFetch(regdNo: _regdNo, password: _password);
    LoginData ld = await loginFetch.getLogin();
    if (ld.status == "success")
      setState(() {
        _setCredentials();
        // _setCredentials();
        _isLoggingIn = true;
        isLoggedIn = true;
        cookie = ld.cookie;
        af = AttendanceFetch();
        rf = ResultFetch();
        pi = ProfileFetch();
        lf = LecturesFetch(semNo: sem);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendancePage(),
            ));
      });
  }

  logout() {
    setState(() {
      name = null;
      sem = null;
      isLoggedIn = false;
      password = null;
      _resetCredentials();
      Fluttertoast.showToast(
        msg: "Logged out!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: OnPop(context: context).onWillPop,
      child: Scaffold(
        drawer: CustomAppDrawer(srestart: true).widgetDrawer(context),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.apps),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                LineAwesomeIcons.lock,
                size: 20,
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MdViewer(
                          'Privacy Policy', 'assets/policy/PrivacyPolicy.md'))),
              tooltip: 'Privacy Policy',
            ),
            IconButton(
              icon: new Icon(
                Icons.circle_notifications,
                size: 20,
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Notices())),
            ),
          ],
        ),
        bottomSheet: InkWell(
          onTap: () => Wiredash.of(context).show(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  LineAwesomeIcons.bug,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Report a Bug',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: !_isLoggingIn
            ? SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isLoggingIn = false;
                    isLoading = false;
                    password = null;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    name = null;
                    sem = null;
                  });
                },
                backgroundColor: themeDark,
                tooltip: 'Cancel Login',
                child: Icon(
                  LineAwesomeIcons.close,
                  color:
                      brightness == Brightness.dark || themeDark == themeDark1
                          ? Colors.white
                          : Colors.black,
                ),
              ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text(
                    'ITER - AIO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                new Container(
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                  child: new FlareActor("assets/animations/ITER-AIO.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: animationName),
                ),
                Center(
                  child: Text(
                    'Let\'s Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                /// Regd No. Input
                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.continueAction,
                  autofocus: false,
                  initialValue: regdNo,
                  cursorColor: themeDark,
                  onChanged: (String str) {
                    setState(() {
                      regdNo = str;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      animationName = 'ok';
                    });
                  },
                  onTap: () {
                    setState(() {
                      if (animationName == 'closeEyes')
                        animationName = 'openEyes';
                      else
                        animationName = 'still';
                      Future.delayed(Duration(milliseconds: 1500))
                          .whenComplete(() {
                        setState(() {
                          animationName = 'hello';
                        });
                      });
                    });
                  },
                  enabled: !_isLoggingIn,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    icon: Icon(Icons.person_outline),
                    hintText: 'Regd No.',
                    fillColor: themeDark,
                    focusColor: themeDark,
                    hoverColor: themeDark,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                /// Password Input
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.go,
                        autofocus: false,
                        initialValue: password,
                        cursorColor: themeDark,
                        onChanged: (String str) {
                          setState(() {
                            password = str;
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            animationName = 'openEyes';
                          });
                        },
                        onTap: () {
                          setState(() {
                            animationName = 'closeEyes';
                          });
                        },
                        enabled: !_isLoggingIn,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          icon: Icon(Icons.lock_outline),
                          hintText: 'Password',
                          fillColor: themeDark,
                          focusColor: themeDark,
                          hoverColor: themeDark,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(LineAwesomeIcons.eye),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),

                /// Login button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: regdNo != null && password != null && _isLoggingIn
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          width: double.maxFinite,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () async {
                              print('$regdNo : $password');
                              await _login(regdNo, password);
                              setState(() {
                                animationName = 'openEyes';
                                Future.delayed(Duration(seconds: 1))
                                    .whenComplete(() {
                                  setState(() {
                                    animationName = 'hello';
                                  });
                                });
                              });
                              Future.delayed(Duration(seconds: 15))
                                  .whenComplete(() => _setCredentials());
                              try {
                                if (loginFetch.finalLogin.status == 'success') {
                                  isLoading = true;
                                  _isLoggingIn = true;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AttendancePage(),
                                      ));
                                } else
                                  Fluttertoast.showToast(
                                    msg: loginFetch.finalLogin.message,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                              } on Exception catch (e) {
                                debugPrint('$e');
                              }
                            },
                            padding: EdgeInsets.all(12),
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? themeLight
                                    : themeDark,
                            child: Text('Log In',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('open', true);
    await prefs.setString('regd', regdNo);
    await prefs.setString('password', password);
    await prefs.setInt('sem', pi.finalProfile.semester);
    await prefs.setString('theme', themeStr);
  }

  _getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('initTime') != null) {
        initTime = DateTime.parse(prefs.getString('initTime'));
        print('time: ' + prefs.getString('initTime'));
      }
      brightness =
          prefs.getBool('isbright') != null && prefs.getBool('isbright')
              ? Brightness.light
              : Brightness.dark;
      if (prefs.getString('theme') != null) themeStr = prefs.getString('theme');
      if (prefs.getString('regd') != null) regdNo = prefs.getString('regd');
      if (prefs.getInt('sem') != null) sem = prefs.getInt('sem');
      if (prefs.getString('password') != null)
        password = prefs.getString('password');
      // if (noInternet) {
      //   getoldData();
      // }
      setState(() {
        getTheme(themeStr);
      });
      if (regdNo != null && password != null && appStarted && !noInternet) {
        appStarted = false;
        // isLoading = true;
        _isLoggingIn = true;
        _login(regdNo, password);
      }
    });
  }

  _resetCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('regd');
    prefs.remove('password');
    prefs.remove('sem');
  }
}
