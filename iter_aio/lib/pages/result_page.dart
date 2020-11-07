import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/Icons.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/models/result_model.dart';
import 'package:iteraio/pages/attendance_page.dart';
import 'package:iteraio/widgets/large_appdrawer.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:iteraio/widgets/show_notification.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class ResultPage extends StatefulWidget {
  static const routeName = "/result-page";
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<CGPASemResult> finalRes = [];
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 1500;
  Widget load = Container(height: 200, child: loading());
  var _profile, _result;
  Timer _t1, _t2;

  @override
  void initState() {
    _t1 = Timer(Duration(seconds: 10), () {
      setState(() {
        load = Container(
            alignment: Alignment.center,
            child: Text('Sorry No Result for now come back later'));
      });
    });
    _t2 = Timer(Duration(milliseconds: 500), () {
      if (!serverError /* || loginFetch.finalLogin.status != 'Error Logging In'*/)
        setState(() {
          _profile = pi.getProfile();
          _result = rf.getResult();
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        centerTitle: true,
        elevation: 15,
        leading: MediaQuery.of(context).size.width > 700
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        actions: <Widget>[
          if (isMobile)
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: IconButton(
                icon: new Icon(Icons.share),
                onPressed: () {
                  if (isMobile)
                    Notify()
                        .showNotification(title: 'Share', body: 'Share Result');
                  return ShareFilesAndScreenshotWidgets().shareScreenshot(
                      previewContainer,
                      originalSize,
                      "MyResult",
                      "MyResult.png",
                      "image/png",
                      text:
                          "Download ITER-AIO from here http://tiny.cc/iteraio");
                },
              ),
            ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: RepaintBoundary(
        key: previewContainer,
        child: Row(
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
                      // if (rf.finalResult != null)

                      FutureBuilder(
                          future: _getcgpa(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return SizedBox();
                            else
                              return Text(
                                'CGPA : ' + snapshot.data.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black87
                                ),
                              );
                          }),
                      FutureBuilder<List<CGPASemResult>>(
                        future: _result,
                        builder: (context, snapshot) {
                          // (context as Element).markNeedsBuild();
                          if (!snapshot.hasData)
                            return load;
                          else {
                            if (snapshot.data == [])
                              return Center(
                                  child:
                                      Text('Sorry No result available yet!'));
                            return Column(
                              children: [
                                for (var data in snapshot.data)
                                  _resultListTile(data),
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

  Widget _resultListTile(CGPASemResult res) {
    GlobalKey key = new GlobalKey(debugLabel: res.sem.toString());
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? colorLight
            : colorDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Slidable(
        secondaryActions: [
          if (isMobile)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: colorDark,
              ),
              child: IconSlideAction(
                caption: 'Share',
                color: Colors.transparent,
                foregroundColor: Colors.white,
                icon: Icons.share,
                closeOnTap: true,
                onTap: () {
                  ShareFilesAndScreenshotWidgets().shareScreenshot(
                      key,
                      originalSize,
                      "Semester${res.sem}Result",
                      "Sem${res.sem}.png",
                      "image/png",
                      text:
                          "My Sem ${res.sem} Result.\nDownload ITER-AIO http://tiny.cc/iteraio");
                },
              ),
            ),
        ],
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.20,
        child: RepaintBoundary(
          key: key,
          child: ExpansionTile(
            initiallyExpanded: false,
            title: Text(
              'Semester : ${res.sem}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '${res.sgpa}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: Image.asset(
              res.sgpa >= 9.0
                  ? 'assets/logos/happy.gif'
                  : res.sgpa >= 7.5
                      ? 'assets/logos/low happy.gif'
                      : res.sgpa <= 5.0
                          ? 'assets/logos/sad.gif'
                          : 'assets/logos/low sad.gif',
              fit: BoxFit.contain,
            ),
            children: <Widget>[
              for (var i in res.details)
                ListTile(
                  leading: Image.asset(
                    subjectAvatar(i.subjectCode),
                    width: 40,
                  ),
                  title: Text(
                    '${i.subjectName}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '${i.grade}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${i.subjectCode}\nEarned Credit : ${i.earnedCredit}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  isThreeLine: true,
                ),
            ],
          ),
        ),
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
                  builder: (context) => AttendancePage(),
                )),
            child: FutureBuilder<ProfileInfo>(
              future: _profile,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return FutureBuilder<LoginData>(
                      future: loginFetch.getLogin(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: Text('Waiting for Info!'),
                          );
                        else
                          return Center(child: Text(snapshot.data.status));
                      });
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

  Future<double> _getcgpa() async {
    double sum = 0.0;
    int cnt = 0;
    // var _res = rf.finalResult != null ? rf.finalResult : 0;
    for (var i in await rf.getResult()) {
      sum = sum + i.sgpa;
      cnt++;
    }
    return (sum ~/ (cnt * 0.01) / 100);
  }

  void dispose() {
    _t1.cancel();
    _t2.cancel();
    super.dispose();
  }
}
