import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Color c1 = Color.fromRGBO(14, 15, 59, 100);
// Color c2 = Color.fromRGBO(7, 64, 123, 100);
// Color c3 = Color.fromRGBO(127, 205, 238, 100);
// Color c4 = Color.fromRGBO(247, 147, 30, 100);
Brightness bright = Brightness.light;

Color colorDark1 = Colors.teal[600];
Color themeDark1 = Colors.teal;

// Color colorDark1 = Colors.redAccent; //Color(0xFFed0b0e);
// Color themeDark1 = Colors.black; //Color(0xFF252527);

Color colorLight1 = Colors.purple[100];
Color themeLight1 = Colors.purple;

Color colorDark2 = Colors.indigo[300];
Color themeDark2 = Colors.indigo;

Color colorLight2 = Colors.lightGreen[300];
Color themeLight2 = Colors.lightGreen;

Color colorDark3 = Colors.deepOrange[400];
Color themeDark3 = Colors.deepOrange;

Color colorLight3 = Colors.blueGrey[300];
Color themeLight3 = Colors.blueGrey;

Color colorDark4 = Colors.blue[300];
Color themeDark4 = Colors.blue;

Color colorLight4 = Colors.deepPurple[300];
Color themeLight4 = Colors.deepPurple;

Color colorDark = colorDark2;
Color themeDark = themeDark2;

Color colorLight = colorDark2;
Color themeLight = themeDark2;

getTheme(String t) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (t) {
    case 'D1':
      colorDark = colorDark1;
      themeDark = themeDark1;
      colorLight = colorDark1;
      themeLight = themeDark1;
      break;
    case 'D2':
      colorDark = colorDark2;
      themeDark = themeDark2;
      colorLight = colorDark2;
      themeLight = themeDark2;
      break;
    case 'D3':
      colorDark = colorDark3;
      themeDark = themeDark3;
      colorLight = colorDark3;
      themeLight = themeDark3;
      break;
    case 'D4':
      colorDark = colorDark4;
      themeDark = themeDark4;
      colorLight = colorDark4;
      themeLight = themeDark4;
      break;
    case 'L1':
      colorDark = colorLight1;
      themeDark = themeLight1;
      colorLight = colorLight1;
      themeLight = themeLight1;
      break;
    case 'L2':
      colorDark = colorLight2;
      themeDark = themeLight2;
      colorLight = colorLight2;
      themeLight = themeLight2;
      break;
    case 'L3':
      colorDark = colorLight3;
      themeDark = themeLight3;
      colorLight = colorLight3;
      themeLight = themeLight3;
      break;
    case 'L4':
      colorDark = colorLight4;
      themeDark = themeLight4;
      colorLight = colorLight4;
      themeLight = themeLight4;
      break;
    default:
      colorDark = colorDark2;
      themeDark = themeDark2;
      colorLight = colorDark2;
      themeLight = themeDark2;
    // break;
  }
  await prefs.setString('theme', t);
}
