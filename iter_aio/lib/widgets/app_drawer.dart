import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/pages/attendance_page.dart';
import 'package:iteraio/pages/notices.dart';
import 'package:iteraio/helper/update_fetch.dart';
import 'package:iteraio/pages/aboutus_page.dart';
import 'package:iteraio/pages/courses_page.dart';
import 'package:iteraio/pages/login_page.dart';
import 'package:iteraio/pages/planBunk.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/pages/settings.dart';
import 'package:iteraio/widgets/WebPageView.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppDrawer {
  final bool noInternet;
  final bool slectures; //show Lectures
  final bool sresult; // show results
  final bool sstudyMaterial;
  final bool snotices;
  final bool ssettings;
  final bool saboutUs;
  final bool slogout;
  final bool sbunk;
  final bool srestart;

  CustomAppDrawer(
      {this.noInternet = false,
      this.sbunk = false,
      this.slectures = false,
      this.sresult = false,
      this.sstudyMaterial = true,
      this.snotices = true,
      this.ssettings = true,
      this.saboutUs = true,
      this.srestart = false,
      this.slogout = false});

  Widget widgetDrawer(context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text(
                'ITER-AIO',
                softWrap: true,
              ),
              elevation: 15,
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => Navigator.pop(context, false)),
            ),
            buildNaviDrawer(context)
          ],
        ),
      ),
    );
  }

  Widget buildNaviDrawer(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (MediaQuery.of(context).size.width > 700)
            ListTile(
              leading: Icon(Icons.hail),
              title: Text('Attendance'),
              onTap: () => Navigator.pushReplacementNamed(
                  context, AttendancePage.routeName),
            ),
          if (isUpdateAvailable && isMobile)
            ListTile(
              tileColor: Colors.orangeAccent,
              leading: Icon(Icons.upgrade_rounded),
              title: Text('Update Available!'),
              onTap: () => UpdateFetch().showUpdateDialog(context),
            ),
          if (slectures && !noInternet) Divider(),
          if (slectures && !noInternet)
            ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Lectures'),
                onTap: () =>
                    Navigator.pushNamed(context, CoursesPage.routeName)),
          if (sresult && !noInternet) Divider(),
          if (sresult && !noInternet)
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Result'),
              onTap: () => Navigator.pushNamed(context, ResultPage.routeName),
            ),
          if (sstudyMaterial) Divider(),
          if (sstudyMaterial)
            ListTile(
              leading: Icon(LineAwesomeIcons.book),
              title: Text('Study Materials'),
              onTap: noInternet
                  ? () {
                      if (isMobile)
                        Fluttertoast.showToast(
                          msg: "No Internet!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                    }
                  : !isMobile
                      ? () => _launchURL(
                          'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF8_AqsUEpudWkOl?usp=sharing')
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebPageView(
                                  'ITER Book Shelf',
                                  'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF8_AqsUEpudWkOl?usp=sharing'))),
            ),
          if (snotices) Divider(),
          if (snotices)
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Notices & News'),
              onTap: noInternet
                  ? () {
                      if (isMobile)
                        Fluttertoast.showToast(
                          msg: "No Internet!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                    }
                  : () => Navigator.pushNamed(context, Notices.routeName),
            ),
          if (sbunk) Divider(),
          if (sbunk)
            ListTile(
              leading: Icon(Icons.airline_seat_individual_suite),
              title: Text('Plan a Bunk'),
              onTap: () => Navigator.pushNamed(context, PlanBunk.routeName),
            ),
          if (ssettings) Divider(),
          if (ssettings)
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pushNamed(context, SettingsPage.routeName),
            ),
          if (saboutUs) Divider(),
          if (saboutUs)
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () => Navigator.pushNamed(context, AboutUs.routeName),
            ),
          if (slogout && !noInternet) Divider(),
          if (slogout && !noInternet)
            ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text('Logout'),
                onTap: () => Alert(
                      context: context,
                      onWillPopActive: true,
                      type: AlertType.warning,
                      title: "Do you want to Logout?",
                      buttons: [
                        DialogButton(
                          color: colorDark,
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage(
                                          logout: true,
                                        )));
                          },
                        ),
                        DialogButton(
                          color: colorDark,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ).show()),
          if (srestart) Divider(),
          if (srestart)
            ListTile(
                leading: Icon(LineAwesomeIcons.refresh),
                title: Text('Restart App'),
                onTap: () => Phoenix.rebirth(context)),
        ],
      ),
    );
  }

  Widget buildLargeNaviDrawer(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (MediaQuery.of(context).size.width > 700)
            ListTile(
              leading: Icon(Icons.hail),
              title: Text('Attendance'),
              onTap: () => Navigator.pushReplacementNamed(
                  context, AttendancePage.routeName),
            ),
          if (slectures && !noInternet) Divider(),
          if (slectures && !noInternet)
            ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Lectures'),
                onTap: () => Navigator.pushReplacementNamed(
                    context, CoursesPage.routeName)),
          if (sresult && !noInternet) Divider(),
          if (sresult && !noInternet)
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Result'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, ResultPage.routeName),
            ),
          if (snotices) Divider(),
          if (snotices)
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Notices & News'),
              onTap: noInternet
                  ? () {
                      if (isMobile)
                        Fluttertoast.showToast(
                          msg: "No Internet!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                    }
                  : () => Navigator.pushReplacementNamed(
                      context, Notices.routeName),
            ),
          if (sstudyMaterial) Divider(),
          if (sstudyMaterial)
            ListTile(
              leading: Icon(LineAwesomeIcons.book),
              title: Text('Study Materials'),
              onTap: () => _launchURL(
                  'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF8_AqsUEpudWkOl?usp=sharing'),
            ),
          if (sbunk) Divider(),
          if (sbunk)
            ListTile(
              leading: Icon(Icons.airline_seat_individual_suite),
              title: Text('Plan a Bunk'),
              onTap: () => Navigator.restorablePopAndPushNamed(
                  context, PlanBunk.routeName),
            ),
          if (ssettings) Divider(),
          if (ssettings)
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pushReplacementNamed(
                  context, SettingsPage.routeName),
            ),
          if (saboutUs) Divider(),
          if (saboutUs)
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AboutUs.routeName),
            ),
          if (slogout && !noInternet) Divider(),
          if (slogout && !noInternet)
            ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text('Logout'),
                onTap: () => Alert(
                      context: context,
                      onWillPopActive: true,
                      type: AlertType.warning,
                      title: "Do you want to Logout?",
                      buttons: [
                        DialogButton(
                          color: colorDark,
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage(
                                          logout: true,
                                        )));
                          },
                        ),
                        DialogButton(
                          color: colorDark,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ).show()),
          if (srestart) Divider(),
          if (srestart)
            ListTile(
                leading: Icon(LineAwesomeIcons.refresh),
                title: Text('Restart App'),
                onTap: () => Phoenix.rebirth(context)),
        ],
      ),
    );
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
