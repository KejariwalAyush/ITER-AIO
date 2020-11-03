import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/components/Icons.dart';
import 'package:iteraio/components/about.dart';
import 'package:iteraio/components/notices.dart';
import 'package:iteraio/components/settings.dart';
import 'package:iteraio/models/attendance_info.dart';
import 'package:iteraio/pages/courses_page.dart';
import 'package:iteraio/pages/planBunk.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/widgets/WebPageView.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../MyHomePage.dart';

class AttendancePage extends StatefulWidget {
  static const routeName = "attendance-page";
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
      appBar: AppBar(
        title: Text('ITER AIO'),
        centerTitle: true,
        elevation: 15,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(Icons.apps),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: <Widget>[
          Stack(
            children: [
              IconButton(
                icon: new Icon(
                  Icons.notifications,
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notices())),
              ),
              newNotification
                  ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          ' ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : new Container()
            ],
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(5),
                child: buildHeader(context),
              ),
              FutureBuilder<AttendanceInfo>(
                future: af.getAttendance(),
                builder: (context, snapshot) {
                  // (context as Element).markNeedsBuild();
                  if (!snapshot.hasData)
                    return Container(height: 200, child: loading());
                  else {
                    if (snapshot.data.data == null)
                      return Container(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              child: FlareActor(
                                  "assets/animations/ITER-AIO.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: "hello"),
                            ),
                            Text(
                              'Sorry,\nNo Attendence Available Right Now,\nCome Back Later',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text('\nUntil Then Check Other Things We Have'),
                            SizedBox(
                              height: 10,
                            ),
                            buildNaviDrawer(context),
                          ],
                        ),
                      ));
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Avg Attendence: ${snapshot.data.avgAttPer} %',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Avg Absent: ${snapshot.data.avgAbsPer}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        for (var data in snapshot.data.data)
                          _attandenceExpansionTile(data),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attandenceExpansionTile(SubjectAttendance sat) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? colorLight
            : colorDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text(
          '${sat.subject}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Code: ${sat.subjectCode}'),
        trailing: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: sat.totAtt > 90
                ? Colors.green
                : sat.totAtt > 80
                    ? Colors.lightGreen
                    : sat.totAtt > 75
                        ? Colors.orangeAccent
                        : Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${sat.totAtt} %',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Image.asset(
          subjectAvatar(sat.subjectCode),
          width: 40,
          alignment: Alignment.center,
        ),
        children: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Updated On: ${sat.lastUpdatedOn.hour}',
                        textAlign: TextAlign.start,
                      ),
                      if (sat.lattper != 0 && sat.latt != 'Not Applicable')
                        Text(
                          'Lab: \t\t\t${sat.latt} (${sat.lattper}%)',
                          textAlign: TextAlign.start,
                        ),
                      if (sat.patt != '0 / 0' && sat.patt != 'Not Applicable')
                        Text(
                          'Practical: \t\t\t${sat.patt} (${sat.pattper}%)',
                          textAlign: TextAlign.start,
                        ),
                      if (sat.tatt != '0 / 0' && sat.tatt != 'Not Applicable')
                        Text(
                          'Theory: \t\t\t${sat.tatt} (${sat.tattper}%)',
                          textAlign: TextAlign.start,
                        ),
                      Text(
                        'Present: ${sat.present}',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Absent: ${sat.absent}',
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Image.asset(
                    sat.totAtt >= 90
                        ? 'assets/logos/happy.gif'
                        : sat.totAtt > 80
                            ? 'assets/logos/low happy.gif'
                            : sat.totAtt > 75
                                ? 'assets/logos/low sad.gif'
                                : 'assets/logos/sad.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              sat.bunkText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Row buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: 80,
            // width: 100,
            child: FlareActor("assets/animations/ITER-AIO.flr",
                alignment: Alignment.center,
                fit: BoxFit.cover,
                animation: "hello"),
          ),
        ),
        Expanded(
          flex: 3,
          child: Hero(
            tag: 'home animation',
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(),
                  )),
              child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                    text: '$name',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black87
                          : Colors.white,
                    ),
                    children: [
                      TextSpan(
                          text: '\nRegd. No.:$regdNo',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black54
                                    : Colors.white60,
                          )),
                      TextSpan(
                          text: '\nSemester: $sem',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black54
                                    : Colors.white60,
                          )),
                    ]),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildNaviDrawer(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // if (isLoggedIn || sem != null) Divider(),
          // if (isLoggedIn || sem != null)
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('Lectures'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => CoursesPage())),
          ),
          if (isLoggedIn || sem != null) Divider(),
          if (isLoggedIn || sem != null)
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
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebPageView('ITER Book Shelf',
                        'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF8_AqsUEpudWkOl?usp=sharing'))),
          ),
          if (isLoggedIn &&
              (attendData != null ? attendData[0] != null : false))
            Divider(),
          if (isLoggedIn &&
              (attendData != null ? attendData[0] != null : false))
            ListTile(
              leading: Icon(Icons.airline_seat_individual_suite),
              title: Text('Plan a Bunk'),
              onTap: isLoading
                  ? null
                  : () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlanBunk())),
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: isLoading
                ? null
                : () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Us'),
            onTap: isLoading
                ? null
                : () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs())),
          ),
        ],
      ),
    );
  }
}
