import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/components/about.dart';
import 'package:iteraio/components/notices.dart';
import 'package:iteraio/components/settings.dart';
import 'package:iteraio/pages/courses_page.dart';
import 'package:iteraio/pages/login_page.dart';
// import 'package:iteraio/pages/planBunk.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/widgets/WebPageView.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  CustomAppDrawer(
      {this.noInternet = false,
      this.sbunk = false,
      this.slectures = true,
      this.sresult = false,
      this.sstudyMaterial = true,
      this.snotices = true,
      this.ssettings = true,
      this.saboutUs = true,
      this.slogout = false});

  Widget widgetDrawer(context) {
    return Drawer(
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
    );
  }

  Widget buildNaviDrawer(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (slectures && !noInternet)
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('Lectures'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CoursesPage())),
            ),
          if (sresult && !noInternet) Divider(),
          if (sresult && !noInternet)
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Result'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ResultPage())),
            ),
          Divider(),
          ListTile(
            leading: Icon(LineAwesomeIcons.book),
            title: Text('Study Materials'),
            onTap: sstudyMaterial && !noInternet
                ? () {
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
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebPageView('ITER Book Shelf',
                            'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF8_AqsUEpudWkOl?usp=sharing'))),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notices & News'),
            onTap: snotices && !noInternet
                ? () {
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
                : () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notices())),
          ),
          // if (sbunk) Divider(),
          // if (sbunk)
          //   ListTile(
          //     leading: Icon(Icons.airline_seat_individual_suite),
          //     title: Text('Plan a Bunk'),
          //     onTap: () => Navigator.push(
          //         context, MaterialPageRoute(builder: (context) => PlanBunk())),
          //   ),
          if (ssettings) Divider(),
          if (ssettings)
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings())),
            ),
          if (saboutUs) Divider(),
          if (saboutUs)
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutUs())),
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
                            // setState(() {
                            //   attendData = null;
                            //   resultData = null;
                            //   name = null;
                            //   sem = null;
                            //   infoData = null;
                            //   isLoggedIn = false;
                            //   regdNo = null;
                            //   password = null;
                            //   _resetCredentials();
                            //   Fluttertoast.showToast(
                            //     msg: "Logged out!",
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.BOTTOM,
                            //     timeInSecForIosWeb: 2,
                            //     backgroundColor: Colors.blueGrey,
                            //     textColor: Colors.white,
                            //     fontSize: 16.0,
                            //   );
                            // });
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
        ],
      ),
    );
  }
}
