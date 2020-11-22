import 'package:flutter/material.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:iteraio/prelogin/preHome.dart';

class Splash extends StatelessWidget {
  const Splash({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 1,
      //isLoading?sec:1,
      navigateAfterSeconds: isLoggedIn != null
          ? isLoggedIn
              ? new MyHomePage()
              : new PreHome()
          : new PreHome(),
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
