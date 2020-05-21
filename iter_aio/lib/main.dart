import 'package:flutter/material.dart';
import 'package:iteraio/login.dart';

void main() {
  runApp(MyApp());
}

//Color c1 = Color.fromRGBO(14, 15, 59, 100);
//Color c2 = Color.fromRGBO(7, 64, 123, 100);
//Color c3 = Color.fromRGBO(127, 205, 238, 100);
//Color c4 = Color.fromRGBO(247, 147, 30, 100);
//Color c5 = Colors.white;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITER-AIO',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light),
      darkTheme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
