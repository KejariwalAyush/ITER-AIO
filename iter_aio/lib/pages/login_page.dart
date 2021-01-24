import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/helper/notices_fetch.dart';
import 'package:iteraio/pages/notices.dart';
import 'package:iteraio/helper/attendance_fetch.dart';
import 'package:iteraio/helper/lectures_fetch.dart';
import 'package:iteraio/helper/login_fetch.dart';
import 'package:iteraio/helper/profile_fetch.dart';
import 'package:iteraio/helper/result_fetch.dart';
import 'package:iteraio/helper/update_fetch.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/myHomePage.dart';
import 'package:iteraio/widgets/Mdviewer.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/widgets/on_pop.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iteraio/landing/LandingPage.dart';
import 'package:iteraio/pages/attendance_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login-page";
  final bool logout;

  LoginPage({Key key, this.logout = false}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation _animation,
      _delayedAnimation1,
      _delayedAnimation2,
      _delayedAnimation3,
      _bounceAnimation;
  AnimationController _animationController;
  bool _isLoggingIn = false;
  bool isLoading = false;
  String animationName = 'hello';
  bool showPassword = false;

  @override
  void initState() {
    animationInit();
    if (isUpdateAvailable) UpdateFetch().showUpdateDialog(context);
    if (widget.logout) logout();
    // _getCredentials();
    _login(regdNo, password);
    if (sem != null) lf = new LecturesFetch(semNo: sem);
    nf = NoticesFetch();
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
        // lf = LecturesFetch(semNo: sem);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ));
      });
  }

  logout() {
    setState(() {
      name = null;
      sem = null;
      isLoggedIn = false;
      password = null;
      admin = false;
      _resetCredentials();
      if (isMobile)
        Fluttertoast.showToast(
          msg: "Logged out!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      signOutFirebaseAuth();
    });
  }

  Future signOutFirebaseAuth() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: OnPop(context: context).onWillPop,
      child: Scaffold(
        backgroundColor: themeDark.withOpacity(0.9),
        drawer: CustomAppDrawer(srestart: true, sstudyMaterial: false)
            .widgetDrawer(context),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(
                Icons.apps,
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
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
                Icons.notifications_none,
                size: 20,
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Notices())),
            ),
            // IconButton(
            //   icon: new Icon(
            //     Icons.home_outlined,
            //     size: 20,
            //     color:
            //         brightness == Brightness.dark ? Colors.white : Colors.black,
            //   ),
            //   onPressed: () => Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => LandingPage())),
            // ),
          ],
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
                  height: height * 0.02,
                ),
                Transform(
                  transform:
                      Matrix4.translationValues(width * _animation.value, 0, 0),
                  child: Center(
                    child: Text(
                      'Welcome to ITER-AIO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Transform(
                  transform:
                      Matrix4.translationValues(width * _animation.value, 0, 0),
                  child: new Container(
                    height: 220 * _bounceAnimation.value,
                    width: 220 * _bounceAnimation.value,
                    // width: MediaQuery.of(context).size.width,
                    child: new FlareActor("assets/animations/ITER-AIO.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: animationName),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Transform(
                  transform:
                      Matrix4.translationValues(width * _animation.value, 0, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Let\'s Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Transform(
                    transform: Matrix4.translationValues(
                        width * _delayedAnimation1.value, 0, 0),
                    child: regdNoInput()),
                SizedBox(
                  height: 10,
                ),
                Transform(
                    transform: Matrix4.translationValues(
                        width * _delayedAnimation2.value, 0, 0),
                    child: passwordInput()),
                SizedBox(
                  height: height * 0.02,
                ),
                Transform(
                    transform: Matrix4.translationValues(
                        width * _delayedAnimation3.value, 0, 0),
                    child: loginButton(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return Padding(
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
                  setState(() {
                    animationName = 'openEyes';
                    _isLoggingIn = true;
                    Future.delayed(Duration(seconds: 1)).whenComplete(() {
                      setState(() {
                        animationName = 'hello';
                      });
                    });
                  });
                  await _login(regdNo, password);
                  Future.delayed(Duration(seconds: 15))
                      .whenComplete(() => _setCredentials());
                  try {
                    if (loginFetch.finalLogin.status == 'success') {
                      isLoading = true;
                      _isLoggingIn = true;
                      Navigator.pushReplacementNamed(
                          context, AttendancePage.routeName);
                      // context, MyHomePage.routeName);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => MyHomePage(),
                      //     ));
                    } else if (isMobile)
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
                color: Colors.black87,
                child: Text('Log In', style: TextStyle(color: Colors.white)),
              ),
            ),
    );
  }

  Row passwordInput() {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
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
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
    );
  }

  TextFormField regdNoInput() {
    return TextFormField(
      keyboardType: TextInputType.number,
      // textInputAction: TextInputAction.none,
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
          Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  _setCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('open', true);
    await prefs.setString('regd', regdNo);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', isLoggedIn);
    // await prefs.setInt('sem', pi.finalProfile.semester);
    await prefs.setString('theme', themeStr);
  }

  _resetCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('regd');
    prefs.remove('password');
    prefs.remove('isLoggedIn');
    prefs.remove('sem');
  }

  void animationInit() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = Tween<double>(begin: -1, end: 0).animate(CurvedAnimation(
        curve: Interval(0.2, 1, curve: Curves.fastOutSlowIn),
        parent: _animationController))
      ..addListener(() {
        setState(() {});
      });

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        curve: Interval(0.2, 1, curve: Curves.easeIn),
        parent: _animationController))
      ..addListener(() {
        setState(() {});
      });

    _delayedAnimation1 = Tween<double>(begin: -1, end: 0).animate(
        CurvedAnimation(
            curve: Interval(0.4, 1, curve: Curves.fastOutSlowIn),
            parent: _animationController))
      ..addListener(() {
        setState(() {});
      });

    _delayedAnimation2 = Tween<double>(begin: -1, end: 0).animate(
        CurvedAnimation(
            curve: Interval(0.6, 1, curve: Curves.fastOutSlowIn),
            parent: _animationController))
      ..addListener(() {
        setState(() {});
      });

    _delayedAnimation3 = Tween<double>(begin: -1, end: 0).animate(
        CurvedAnimation(
            curve: Interval(0.8, 1, curve: Curves.fastOutSlowIn),
            parent: _animationController))
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();
  }
}
