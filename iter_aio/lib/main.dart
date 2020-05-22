import 'package:flutter/material.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/Themes/Theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITER-AIO',
      theme: ThemeData(
          primarySwatch: themeLight,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light),
      darkTheme: ThemeData(
        primarySwatch: themeDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(color: themeDark
            // Color.fromRGBO(127, 205, 238, 70),
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
