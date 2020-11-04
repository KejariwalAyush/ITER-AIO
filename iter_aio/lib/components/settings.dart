import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

var _brightSwitch = true;

class _SettingsState extends State<Settings> {
  setBrightness(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isbright', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        elevation: 15,
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.feedback),
            onPressed: () {
              Wiredash.of(context).show();
            },
          ),
        ],
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Dark Mode'),
                  Switch.adaptive(
                    value: _brightSwitch,
                    onChanged: (value) {
                      setState(() {
                        _brightSwitch = value;
                        value
                            ? brightness = Brightness.dark
                            : brightness = Brightness.light;
                        setBrightness(!value);
                      });

                      Future.microtask(() async {
                        await setBrightness(!value);
                      }).whenComplete(() => Phoenix.rebirth(context));
                    },
                  ),
                ],
              ),
              Divider(
                height: 10,
                thickness: 2,
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
                        title: Text('Theme 1'),
                        onTap: () {
                          setState(() {
                            //isLoggedIn = false;
                            themeLight = themeLight1;
                            colorLight = colorLight1;
                            themeDark = themeLight1;
                            colorDark = colorLight1;
                          });
                          themeStr = 'L1';

                          Future.microtask(() async {
                            await getTheme(themeStr);
                          }).whenComplete(() => Phoenix.rebirth(context));
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
                        title: Text('Theme 1'),
                        onTap: () {
                          setState(() {
                            //isLoggedIn = false;
                            themeLight = themeDark1;
                            colorLight = colorDark1;
                            themeDark = themeDark1;
                            colorDark = colorDark1;
                          });
                          themeStr = 'D1';
                          Future.microtask(() async {
                            await getTheme(themeStr);
                          }).whenComplete(() => Phoenix.rebirth(context));
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
                        title: Text('Theme 2'),
                        onTap: () {
                          setState(() {
                            //isLoggedIn = false;
                            themeLight = themeLight2;
                            colorLight = colorLight2;
                            themeDark = themeLight2;
                            colorDark = colorLight2;
                          });
                          themeStr = 'L2';

                          Future.microtask(() async {
                            await getTheme(themeStr);
                          }).whenComplete(() => Phoenix.rebirth(context));
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
                        title: Text('Theme 2'),
                        onTap: () {
                          setState(() {
                            //isLoggedIn = false;
                            themeLight = themeDark2;
                            colorLight = colorDark2;
                            themeDark = themeDark2;
                            colorDark = colorDark2;
                          });
                          themeStr = 'D2';

                          Future.microtask(() async {
                            await getTheme(themeStr);
                          }).whenComplete(() => Phoenix.rebirth(context));
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
                        title: Text('Theme 3'),
                        onTap: () {
                          setState(() {
                            //isLoggedIn = false;
                            themeLight = themeLight3;
                            colorLight = colorLight3;
                            themeDark = themeLight3;
                            colorDark = colorLight3;
                          });
                          themeStr = 'L3';

                          Future.microtask(() async {
                            await getTheme(themeStr);
                          }).whenComplete(() => Phoenix.rebirth(context));
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
                        title: Text('Theme 3'),
                        onTap: () {
                          setState(() {
                            //isLoggedIn = false;
                            themeLight = themeDark3;
                            colorLight = colorDark3;
                            themeDark = themeDark3;
                            colorDark = colorDark3;
                          });
                          themeStr = 'D3';

                          Future.microtask(() async {
                            await getTheme(themeStr);
                          }).whenComplete(() => Phoenix.rebirth(context));
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
                        title: Text('Theme 4'),
                        onTap: () {
                          setState(() {
                            //isLoggedIn = false;
                            themeLight = themeLight4;
                            colorLight = colorLight4;
                            themeDark = themeLight4;
                            colorDark = colorLight4;
                          });
                          themeStr = 'L4';

                          Future.microtask(() async {
                            await getTheme(themeStr);
                          }).whenComplete(() => Phoenix.rebirth(context));
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
                        title: Text('Theme 4'),
                        onTap: () {
                          setState(() {
                            //isLoggedIn = false;
                            themeLight = themeDark4;
                            colorLight = colorDark4;
                            themeDark = themeDark4;
                            colorDark = colorDark4;
                          });
                          themeStr = 'D4';

                          Future.microtask(() async {
                            await getTheme(themeStr);
                          }).whenComplete(() => Phoenix.rebirth(context));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 5, thickness: 2,
                // color: Colors.black,
              ),
              InkWell(
                onTap: () => Wiredash.of(context).show(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        LineAwesomeIcons.bug,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Report a Bug/Request a feature',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
