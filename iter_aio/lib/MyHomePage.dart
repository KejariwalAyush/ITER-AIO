import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/pages/attendance_page.dart';
import 'package:iteraio/pages/events/events_page.dart';
import 'package:iteraio/pages/profile/profile_page.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/pages/clubs/clubs_page.dart';
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
                  label: 'Attendance',
                ),
                if (isMobile || !noInternet)
                  BottomNavigationBarItem(
                    icon: Icon(Icons.event_note),
                    label: 'Events',
                  )
                else
                  BottomNavigationBarItem(
                    icon: Icon(Icons.description),
                    label: 'Result',
                  ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                if (isMobile || !noInternet)
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group),
                    label: 'Clubs',
                  ),
              ],
              type: BottomNavigationBarType.shifting,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.orangeAccent,
              unselectedItemColor: brightness == Brightness.dark
                  ? Colors.white60
                  : Colors.black87,
              elevation: 15,
              currentIndex: _currentIndex,
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              selectedFontSize: 14,
              unselectedFontSize: 12,
              unselectedIconTheme: IconThemeData(size: 20),
              selectedIconTheme: IconThemeData(size: 30),
            ),
      body: Row(
        children: [
          Expanded(
            flex: 10,
            child: GestureDetector(
              child: pageChooser(_currentIndex),
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

  Widget pageChooser(int _index) {
    switch (_index) {
      case 0:
        return AttendancePage();
        break;
      case 1:
        return isMobile ? EventsPage() : ResultPage();
        break;
      case 2:
        return ProfilePage();
        break;
      case 3:
        return ClubsPage();
        break;
      default:
        return AttendancePage();
    }
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
        isMobile || !noInternet
            ? textDestination("Events", Icon(Icons.event_note))
            : textDestination("Result", Icon(Icons.description)),
        textDestination("Profile", Icon(Icons.person)),
        if (isMobile || !noInternet)
          textDestination("Clubs", Icon(Icons.group)),
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
