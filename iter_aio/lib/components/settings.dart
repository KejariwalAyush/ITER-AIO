import 'package:flutter/material.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/Themes/Theme.dart';
import 'package:iteraio/main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // var _brightSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                'Change Theme',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 8,
              ),
              Theme.of(context).brightness == Brightness.light
                  ? Text(
                      'Dark theme gets into action when \nSystem wide Dark Mode is Active & vise versa',
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'Light theme gets into action when \nSystem wide Light Mode is Active & vise versa',
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
              SizedBox(
                height: 8,
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Expanded(child: Text('Dark Mode')),
              //       Switch(
              //         onChanged: (value) {
              //           setState(() {
              //             _brightSwitch
              //                 ? bright = Brightness.dark
              //                 : bright = Brightness.light;
              //             // _brightSwitch
              //           });
              //         },
              //         value: _brightSwitch,
              //       ),
              //     ],
              //   ),
              // ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeLight1,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text('Light Theme 1'),
                        onTap: () {
                          setState(() {
                            isLoggedIn = true;
                            themeLight = themeLight1;
                            colorLight = colorLight1;
                            themeDark = themeLight1;
                            colorDark = colorLight1;
                          });
                          themeStr = 'L1';
                          getTheme(themeStr);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeDark1,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text('Dark Theme 1'),
                        onTap: () {
                          setState(() {
                            isLoggedIn = true;
                            themeLight = themeDark1;
                            colorLight = colorDark1;
                            themeDark = themeDark1;
                            colorDark = colorDark1;
                          });
                          themeStr = 'D1';
                          getTheme(themeStr);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeLight2,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text('Light Theme 2'),
                        onTap: () {
                          setState(() {
                            isLoggedIn = true;
                            themeLight = themeLight2;
                            colorLight = colorLight2;
                            themeDark = themeLight2;
                            colorDark = colorLight2;
                          });
                          themeStr = 'L2';
                          getTheme(themeStr);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeDark2,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text('Dark Theme 2'),
                        onTap: () {
                          setState(() {
                            isLoggedIn = true;
                            themeLight = themeDark2;
                            colorLight = colorDark2;
                            themeDark = themeDark2;
                            colorDark = colorDark2;
                          });
                          themeStr = 'D2';
                          getTheme(themeStr);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeLight3,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text('Light Theme 3'),
                        onTap: () {
                          setState(() {
                            isLoggedIn = true;
                            themeLight = themeLight3;
                            colorLight = colorLight3;
                            themeDark = themeLight3;
                            colorDark = colorLight3;
                          });
                          themeStr = 'L3';
                          getTheme(themeStr);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeDark3,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text('Dark Theme 3'),
                        onTap: () {
                          setState(() {
                            isLoggedIn = true;
                            themeLight = themeDark3;
                            colorLight = colorDark3;
                            themeDark = themeDark3;
                            colorDark = colorDark3;
                          });
                          themeStr = 'D3';
                          getTheme(themeStr);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeLight4,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text('Light Theme 4'),
                        onTap: () {
                          setState(() {
                            isLoggedIn = true;
                            themeLight = themeLight4;
                            colorLight = colorLight4;
                            themeDark = themeLight4;
                            colorDark = colorLight4;
                          });
                          themeStr = 'L4';
                          getTheme(themeStr);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeDark4,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text('Dark Theme 4'),
                        onTap: () {
                          setState(() {
                            isLoggedIn = true;
                            themeLight = themeDark4;
                            colorLight = colorDark4;
                            themeDark = themeDark4;
                            colorDark = colorDark4;
                          });
                          themeStr = 'D4';
                          getTheme(themeStr);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 3,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
