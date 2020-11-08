import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/pages/attendance_page.dart';
import 'package:iteraio/pages/events_page.dart';
import 'package:iteraio/pages/profile_page.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/Utilities/global_var.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = "/home-page";
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: (MediaQuery.of(context).size.width > 700)
          ? SizedBox.shrink()
          : BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.perm_contact_cal),
                    // ignore: deprecated_member_use
                    title: Text('Attendance')),
                if (isMobile)
                  BottomNavigationBarItem(
                      icon: Icon(Icons.event_note),
                      // ignore: deprecated_member_use
                      title: Text('Events'))
                else
                  BottomNavigationBarItem(
                      icon: Icon(Icons.description),
                      // ignore: deprecated_member_use
                      title: Text('Result')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    // ignore: deprecated_member_use
                    title: Text('Profile')),
              ],
              selectedItemColor: Colors.orangeAccent,
              elevation: 10,
              currentIndex: _currentIndex,
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              selectedFontSize: 16,
              unselectedFontSize: 0,
              unselectedIconTheme: IconThemeData(size: 30),
              // selectedIconTheme: IconThemeData(size: 16),
            ),
      body: Row(
        children: [
          Expanded(
            flex: 10,
            child: GestureDetector(
              child: _currentIndex == 0 || _currentIndex == 1
                  ? _currentIndex == 0
                      ? AttendancePage()
                      : isMobile
                          ? EventsPage()
                          : ResultPage()
                  : ProfilePage(),
            ),
          ),
          if (MediaQuery.of(context).size.width > 700)
            Expanded(
              flex: 1,
              child: verticalNavigationBar(),
            ),
        ],
      ),
    );
  }

  Widget verticalNavigationBar() {
    return NavigationRail(
      minWidth: 30.0,
      groupAlignment: 0.0,
      backgroundColor: colorDark,
      selectedIndex: _currentIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: <Widget>[
          // CircleAvatar(
          //   backgroundImage: AssetImage('assets/logos/maleAvatar.png'),
          // ),
        ],
      ),
      selectedLabelTextStyle: TextStyle(
        color: Colors.orangeAccent,
        fontSize: 14,
        letterSpacing: 1,
        decorationThickness: 2.0,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: 12,
        letterSpacing: 0.8,
      ),
      selectedIconTheme: IconThemeData(color: Colors.orange),
      // unselectedIconTheme: IconThemeData(color: Colors.orange),
      destinations: [
        textDestination("Attendance", Icon(Icons.perm_contact_calendar)),
        isMobile
            ? textDestination("Events", Icon(Icons.event_note))
            : textDestination("Result", Icon(Icons.description)),
        textDestination("Profile", Icon(Icons.person)),
      ],
    );
  }

  NavigationRailDestination textDestination(String text, Icon icon) {
    return NavigationRailDestination(
      icon: icon,
      label: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: RotatedBox(
          quarterTurns: MediaQuery.of(context).size.height > 500 ? -1 : 0,
          child: MediaQuery.of(context).size.height > 500
              ? Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
