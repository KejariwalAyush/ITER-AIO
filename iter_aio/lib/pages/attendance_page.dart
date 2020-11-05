import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/Icons.dart';
import 'package:iteraio/helper/update_fetch.dart';
import 'package:iteraio/pages/notices.dart';
import 'package:iteraio/models/attendance_info.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/pages/result_page.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/widgets/large_appdrawer.dart';
import 'package:iteraio/widgets/on_pop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendancePage extends StatefulWidget {
  static const routeName = "/attendance-page";
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    if (isUpdateAvailable) UpdateFetch().showUpdateDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: OnPop(context: context).onWillPop,
      child: Scaffold(
        drawer: CustomAppDrawer(
                sresult: true, sbunk: true, slogout: true, srestart: true)
            .widgetDrawer(context),
        appBar: AppBar(
          title: Text('ITER AIO'),
          centerTitle: true,
          elevation: 15,
          leading: MediaQuery.of(context).size.width > 700
              ? SizedBox()
              : Builder(
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
                  onPressed: () =>
                      Navigator.pushNamed(context, Notices.routeName),
                ),
                // newNotification
                //     ? new Positioned(
                //         right: 11,
                //         top: 11,
                //         child: new Container(
                //           padding: EdgeInsets.all(2),
                //           decoration: new BoxDecoration(
                //             color: Colors.red,
                //             borderRadius: BorderRadius.circular(6),
                //           ),
                //           constraints: BoxConstraints(
                //             minWidth: 14,
                //             minHeight: 14,
                //           ),
                //           child: Text(
                //             ' ',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 8,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //       )
                //     : new Container()
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (MediaQuery.of(context).size.width > 700)
              LargeAppDrawer().largeDrawer(context),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
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
                          if (!snapshot.hasData)
                            // return af.requestSucess()
                            //     ? Container(height: 200, child: loading())
                            return buildNoAttendenceScreen(context);
                          else {
                            if (snapshot.data.attendAvailable == false)
                              return buildNoAttendenceScreen(context);
                            else
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
            ),
          ],
        ),
      ),
    );
  }

  Container buildNoAttendenceScreen(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 150,
            child: FlareActor("assets/animations/ITER-AIO.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "hello"),
          ),
          Text(
            'Oops,\nNo Attendence,\nCome Back Later',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('\nUntil Then Check Other Things We Have'),
          SizedBox(
            height: 10,
          ),
          CustomAppDrawer(sresult: true).buildNaviDrawer(context),
        ],
      ),
    ));
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
                      FutureBuilder<String>(
                          future: _getLastUpdatedOn(sat.lastUpdatedOn, sat),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return SizedBox();
                            else
                              return Text(
                                'Last Updated On: ${snapshot.data}',
                                textAlign: TextAlign.start,
                              );
                          }),
                      if (sat.lattper != 0 && sat.latt != 'Not Applicable')
                        Text(
                          'Lecture: ${sat.latt} (${sat.lattper}%)',
                          textAlign: TextAlign.start,
                        ),
                      if (sat.patt != '0 / 0' && sat.patt != 'Not Applicable')
                        Text(
                          'Practical: ${sat.patt} (${sat.pattper}%)',
                          textAlign: TextAlign.start,
                        ),
                      if (sat.tatt != '0 / 0' && sat.tatt != 'Not Applicable')
                        Text(
                          'Theory: ${sat.tatt} (${sat.tattper}%)',
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

  Future<String> _getLastUpdatedOn(DateTime time, SubjectAttendance x) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String td;
    Duration diff;
    bool attUpdate = false;
    if (prefs.getStringList(x.subjectCode) != null) {
      var osa = prefs.getStringList(x.subjectCode);

      if (int.parse(osa[0]) > x.classes) {
        setState(() {
          attUpdate = true;
        });
        print('attendance Updated');
        await prefs.setStringList(
            x.subjectCode, [x.classes.toString(), x.lastUpdatedOn.toString()]);
      }
    }
    // var notify = Notify();
    // notify.showNotification;

    if (!attUpdate) if (prefs.getStringList(x.subjectCode) != null) {
      var dt = DateTime.parse(prefs.getStringList(x.subjectCode)[1]);
      // if (dt != null) print(dt.toString());
      // print('now:' + time.toString());
      diff = DateTime.now().difference(dt);
      // print(diff.inSeconds);
    }

    if (diff != null && !diff.isNegative) {
      if (diff.inSeconds > 60) {
        if (diff.inMinutes > 60) {
          if (diff.inHours > 24)
            td = diff.inDays.toString() + ' days ago';
          else
            td = diff.inHours.toString() + ' hours ago';
        } else
          td = diff.inMinutes.toString() + ' mins ago';
      } else
        td = 'Few secs ago';
    } else
      td = 'Just Now';
    // '${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute} ${time.hour > 12 ? 'PM' : 'AM'} ${time.day}/${time.month}';
    // print(td);
    return td;
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
                fit: BoxFit.contain,
                animation: "hello"),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(),
                )),
            child: FutureBuilder<ProfileInfo>(
              future: pi.getProfile(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Text('Wating for info!');
                else
                  return RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                        text: snapshot.data.name,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black87
                                  : Colors.white,
                        ),
                        children: [
                          TextSpan(
                              text: '\nRegd. No.:${snapshot.data.regdno}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black54
                                    : Colors.white60,
                              )),
                          TextSpan(
                              text: '\nSemester: ${snapshot.data.semester}\n' +
                                  snapshot.data.sectioncode,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black54
                                    : Colors.white60,
                              )),
                        ]),
                  );
              },
            ),
          ),
        )
      ],
    );
  }
}
