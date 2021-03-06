import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/pages/notices.dart';
import 'package:iteraio/helper/update_fetch.dart';
import 'package:iteraio/pages/sides/aboutus_page.dart';
import 'package:iteraio/pages/sides/courses_page.dart';
import 'package:iteraio/pages/login_page.dart';
import 'package:iteraio/pages/sides/planBunk.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/pages/sides/settings.dart';
import 'package:iteraio/widgets/WebPageView.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/pages/clubs/clubs_page.dart';

class CustomAppDrawer {
  final bool slectures; //show Lectures
  final bool sresult; // show results
  final bool sstudyMaterial;
  final bool snotices;
  final bool ssettings;
  final bool saboutUs;
  final bool slogout;
  final bool sbunk;
  final bool srestart;
  final bool sclub;

  CustomAppDrawer(
      {this.sbunk = false,
      this.slectures = false,
      this.sresult = false,
      this.sstudyMaterial = true,
      this.snotices = true,
      this.ssettings = true,
      this.saboutUs = true,
      this.srestart = false,
      this.sclub = false,
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.home_work),
              title: Text('Home'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, MyHomePage.routeName),
            ),
          if (isUpdateAvailable && isMobile)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              tileColor: Colors.orangeAccent,
              leading: Icon(Icons.upgrade_rounded),
              title: Text('Update Available!'),
              onTap: () => UpdateFetch().showUpdateDialog(context),
            ),
          if (sclub && !noInternet) Divider(),
          if (sclub && !noInternet)
            ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                leading: Icon(Icons.video_library),
                title: Text('Clubs'),
                onTap: () => Navigator.pushNamed(context, ClubsPage.routeName)),
          if (sstudyMaterial) Divider(),
          if (sstudyMaterial)
            InkWell(
              onTap: noInternet
                  ? () {
                      if (isMobile)
                        Fluttertoast.showToast(
                          msg: "No Internet!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 0,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                    }
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebPageView(
                              'Moodle', 'http://136.233.14.6/moodle/my/'))),
              child: Column(
                children: [
                  Container(
                    height: 75,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/icons/moodle.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Moodle ITER",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (slectures && !noInternet) Divider(),
          if (slectures && !noInternet)
            ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                leading: Icon(Icons.video_library),
                title: Text('Lectures'),
                onTap: () =>
                    Navigator.pushNamed(context, CoursesPage.routeName)),
          if (sresult && !noInternet) Divider(),
          if (sresult && !noInternet)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.assignment),
              title: Text('Result'),
              onTap: () => Navigator.pushNamed(context, ResultPage.routeName),
            ),
          if (sstudyMaterial) Divider(),
          if (sstudyMaterial)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(LineAwesomeIcons.book),
              title: Text('Study Materials'),
              onTap: noInternet
                  ? () {
                      if (isMobile)
                        Fluttertoast.showToast(
                          msg: "No Internet!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 0,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                    }
                  : !isMobile
                      ? () => _launchURL(
                          'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF2_AqsUEpudWkOl?usp=sharing')
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebPageView(
                                  'ITER Book Shelf',
                                  'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF2_AqsUEpudWkOl?usp=sharing'))),
            ),
          if (snotices) Divider(),
          if (snotices)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.notifications_none),
              title: Text('Notices & News'),
              onTap: noInternet
                  ? () {
                      if (isMobile)
                        Fluttertoast.showToast(
                          msg: "No Internet!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 0,
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.airline_seat_individual_suite),
              title: Text('Plan a Bunk'),
              onTap: () => Navigator.pushNamed(context, PlanBunk.routeName),
            ),
          if (isMobile) Divider(),
          if (isMobile)
            ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                leading: Icon(Icons.offline_share),
                title: Text('Share App'),
                onTap: () => ShareFilesAndScreenshotWidgets().shareScreenshot(
                    logo, 2040, "logo", "logo.png", "image/png",
                    text:
                        "Download ITER-AIO to know yours from the link below. Get latest Attendance, Result Notices, etc. \n\nVisit: http://tiny.cc/iteraio")),
          if (ssettings) Divider(),
          if (ssettings)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pushNamed(context, SettingsPage.routeName),
            ),
          if (saboutUs) Divider(),
          if (saboutUs)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () => Navigator.pushNamed(context, AboutUs.routeName),
            ),
          if (slogout && !noInternet) Divider(),
          if (slogout && !noInternet)
            ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.home_work),
              title: Text('Home'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, MyHomePage.routeName),
            ),
          if (slectures && !noInternet) Divider(),
          if (slectures && !noInternet)
            ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                leading: Icon(Icons.video_library),
                title: Text('Lectures'),
                onTap: () => Navigator.pushReplacementNamed(
                    context, CoursesPage.routeName)),
          if (sresult && !noInternet && isMobile) Divider(),
          if (sresult && !noInternet && isMobile)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.assignment),
              title: Text('Result'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, ResultPage.routeName),
            ),
          if (snotices) Divider(),
          if (snotices)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.notifications_none),
              title: Text('Notices & News'),
              onTap: noInternet
                  ? () {
                      if (isMobile)
                        Fluttertoast.showToast(
                          msg: "No Internet!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 0,
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(LineAwesomeIcons.book),
              title: Text('Study Materials'),
              onTap: () => _launchURL(
                  'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF2_AqsUEpudWkOl?usp=sharing'),
            ),
          if (sbunk) Divider(),
          if (sbunk)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.airline_seat_individual_suite),
              title: Text('Plan a Bunk'),
              onTap: () => Navigator.restorablePopAndPushNamed(
                  context, PlanBunk.routeName),
            ),
          if (ssettings) Divider(),
          if (ssettings)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pushReplacementNamed(
                  context, SettingsPage.routeName),
            ),
          if (saboutUs) Divider(),
          if (saboutUs)
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AboutUs.routeName),
            ),
          if (slogout && !noInternet) Divider(),
          if (slogout && !noInternet)
            ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
