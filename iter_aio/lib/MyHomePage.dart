import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iteraio/Themes/Theme.dart';
import 'package:iteraio/components/Icons.dart';
import 'package:iteraio/components/about.dart';
import 'package:iteraio/components/courses.dart';
import 'package:iteraio/components/notices.dart';
import 'package:iteraio/components/planBunk.dart';
import 'package:iteraio/components/result.dart';
import 'package:html/parser.dart';
import 'package:iteraio/components/settings.dart';
import 'package:iteraio/main.dart';
import 'package:iteraio/widgets/WebPageView.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

var attendData, infoData;
var resultData, courseData;
var name, branch, gender, avgAttend, avgAbsent, regdNo, password, themeStr;
int sem;
var isLoading = false;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var isLoggedIn = false, dataLoading = false;

class _MyHomePageState extends State<MyHomePage> {
  var _isLoggingIn = false;
  var acedemicCalenderLink;
  String animationName;
  // var curriculumLink;
  @override
  void initState() {
    setState(() {
      animationName = 'hello';
      _getCredentials();
      getCalender();
    });
    super.initState();
  }

  _setCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('regd', regdNo);
    await prefs.setString('password', password);
    await prefs.setString('theme', themeStr);
  }

  _resetCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('regd', regdNo);
    // await prefs.setString('password', password);
    prefs.remove('regd');
    prefs.remove('password');
  }

  _getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      brightness =
          prefs.getBool('isbright') != null && prefs.getBool('isbright')
              ? Brightness.light
              : Brightness.dark;
      themeStr = prefs.getString('theme');
      regdNo = prefs.getString('regd');
      password = prefs.getString('password');
      if (noInternet) {
        getoldData();
        // Future.delayed(Duration(seconds: 2))
        //     .then((value) => {if (serverTimeout) noInternet = false});
      }
      setState(() {
        getTheme(themeStr);
      });
      if (regdNo != null && password != null && appStarted && !noInternet) {
        appStarted = false;
        isLoading = true;
        _isLoggingIn = true;
        getData();
        // getResult();
      }
      // print('$regdNo : $password');
    });
  }

  getoldData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      attendData = jsonDecode(prefs.getString('attendence'));
      infoData = jsonDecode(prefs.getString('info'));
      String s = prefs.getString('result');
      resultData = s.substring(1, s.length - 1).split(', ').toList();
      name = infoData["detail"][0]['name'];
      branch = infoData['detail'][0]['branchdesc'];
      sem = attendData['griddata'][0]['stynumber'];
      gender = infoData['detail'][0]['gender'];
      // print(gender);
      double totatt = 0.0;
      int cnt = 0, totAbs = 0;
      for (var i in attendData['griddata']) {
        totatt += i['TotalAttandence'];
        totAbs += (int.parse(i['Latt'].toString().split('/')[1].trim()) +
                int.parse(i['Patt'].toString().split('/')[1].trim()) +
                int.parse(i['Tatt'].toString().split('/')[1].trim())) -
            (int.parse(i['Latt'].toString().split('/')[0].trim()) +
                int.parse(i['Patt'].toString().split('/')[0].trim()) +
                int.parse(i['Tatt'].toString().split('/')[0].trim()));
        cnt++;
      }
      avgAttend = (totatt / cnt).round();
      avgAbsent = totAbs ~/ cnt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoggedIn && !noInternet || attendData == null
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              bottomSheet: InkWell(
                onTap: () => Wiredash.of(context).show(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        LineAwesomeIcons.bug,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Report a Bug',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: isLoading
                  ? SizedBox()
                  : FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _isLoggingIn = false;
                          isLoading = false;
                          attendData = null;
                          resultData = null;
                          name = null;
                          sem = null;
                          infoData = null;
                          regdNo = null;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      },
                      backgroundColor: themeDark,
                      tooltip: 'Cancel LogIn',
                      child: Icon(
                        LineAwesomeIcons.close,
                        // size: 35,
                        color: brightness == Brightness.dark ||
                                themeDark == themeDark1
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
              body: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    Center(
                      child: Text(
                        'ITER - AIO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    new Container(
                      height: 240,
                      width: MediaQuery.of(context).size.width,
                      child: new FlareActor("assets/animations/ITER-AIO.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: animationName),
                    ),
                    Center(
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      // textInputAction: TextInputAction.continueAction,
                      autofocus: false,
                      initialValue: regdNo,
                      cursorColor: themeDark,
                      onChanged: (String str) {
                        regdNo = str;
                        animationName = 'ok';
                      },
                      onTap: () {
                        setState(() {
                          animationName = 'still';
                          Future.delayed(Duration(seconds: 1)).whenComplete(() {
                            setState(() {
                              animationName = 'hello';
                            });
                          });
                        });
                      },
                      enabled: !_isLoggingIn,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        icon: Icon(Icons.person_outline),
                        hintText: 'Regd No.',
                        fillColor: themeDark,
                        focusColor: themeDark,
                        hoverColor: themeDark,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      autofocus: false,
                      initialValue: password,
                      cursorColor: themeDark,
                      onChanged: (String str) {
                        password = str;
                        animationName = 'openEyes';
                      },
                      onTap: () {
                        setState(() {
                          animationName = 'closeEyes';
                        });
                      },
                      enabled: !_isLoggingIn,
                      obscureText: true,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        icon: Icon(Icons.lock_outline),
                        hintText: 'Password',
                        fillColor: themeDark,
                        focusColor: themeDark,
                        hoverColor: themeDark,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: _isLoggingIn && regdNo != null && password != null
                          ? Center(
                              child: CircularProgressIndicator(
                                  // backgroundColor: themeDark,valueColor:,
                                  ))
                          : RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              onPressed: () {
                                print('$regdNo : $password');
                                _setCredentials();
                                attendData = null;
                                resultData = null;
                                name = null;
                                sem = null;
                                infoData = null;
                                setState(() {
                                  animationName = 'openEyes';
                                  Future.delayed(Duration(seconds: 1))
                                      .whenComplete(() {
                                    setState(() {
                                      animationName = 'hello';
                                    });
                                  });
                                  isLoading = true;
                                  _isLoggingIn = true;
                                  getData();
                                  getResult();
                                  // isLoggedIn = true;
                                });
                              },
                              padding: EdgeInsets.all(12),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? themeLight
                                  : themeDark,
                              child: Text('Log In',
                                  style: TextStyle(color: Colors.white)),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              primary: true,
              drawer: widgetDrawer(context),
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
                // actions: <Widget>[
                //   // IconButton(
                //   //   icon: new Icon(Icons.share),
                //   //   onPressed: () {},
                //   // ),
                //   IconButton(
                //     icon: new Icon(Icons.feedback),
                //     onPressed: () {
                //       Wiredash.of(context).show();
                //     },
                //   ),
                // ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
              ),
              body: isLoading || attendData == null
                  ? Center(
                      child: Container(height: 200, child: loading()),
                    )
                  : SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              margin: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 90,
                                      child: FlareActor(
                                          "assets/animations/ITER-AIO.flr",
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain,
                                          animation: "hello"),
                                    ),
                                    // child: CircleAvatar(
                                    //   child: Image.asset(
                                    //     gender == 'M'
                                    //         ? 'assets/logos/maleAvtar.png'
                                    //         : 'assets/logos/femaleAvtar.png',
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    //   radius: 40,
                                    //   backgroundColor: Colors.transparent,
                                    // ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Hero(
                                      tag: 'home animation',
                                      child: InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Result())),
                                        child: RichText(
                                          textAlign: TextAlign.end,
                                          text: TextSpan(
                                              text: '$name',
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colors.black87
                                                    : Colors.white,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: '\nRegd. No.:$regdNo',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Colors.black54
                                                          : Colors.white60,
                                                    )),
                                                TextSpan(
                                                    text: '\nSemester: $sem',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Colors.black54
                                                          : Colors.white60,
                                                    )),
                                                TextSpan(
                                                    text: '\n$branch',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Colors.black54
                                                          : Colors.white60,
                                                    )),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Avg Attendence: $avgAttend %',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.black87
                                    ),
                                  ),
                                  Text(
                                    'Avg Absent: $avgAbsent',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.black87
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Column(
                              children: <Widget>[
                                for (var i in attendData['griddata'])
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: colorDark,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ExpansionTile(
                                      initiallyExpanded: false,
                                      leading: Image.asset(
                                        subjectAvatar(i['subjectcode']),
                                        width: 40,
                                        alignment: Alignment.center,
                                      ),
                                      title: Text(
                                        '${i['subject']}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: i['TotalAttandence'] > 90
                                              ? Colors.green
                                              : i['TotalAttandence'] > 80
                                                  ? Colors.lightGreen
                                                  : i['TotalAttandence'] > 75
                                                      ? Colors.orangeAccent
                                                      : Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${i['TotalAttandence']} %',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      subtitle:
                                          Text('Code: ${i['subjectcode']}'),
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 3.0,
                                                  bottom: 3,
                                                  left: 15,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Last Updated On: ${getTime(i['lastupdatedon'])}',
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    if (i['Latt'] != '0 / 0')
                                                      Text(
                                                        'Theory: \t\t\t${i['Latt']} (${getPercentage(i['Latt']).floor()}%)',
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    if (i['Patt'] != '0 / 0')
                                                      Text(
                                                        'Practical: \t\t\t${i['Patt']} (${getPercentage(i['Patt']).floor()}%)',
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    if (i['Tatt'] != '0 / 0')
                                                      Text(
                                                        'Tatt: \t\t\t${i['Tatt']} (${getPercentage(i['Tatt']).floor()}%)',
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    Text(
                                                      'Present: ${int.parse(i['Latt'].toString().split('/')[0].trim()) + int.parse(i['Patt'].toString().split('/')[0].trim()) + int.parse(i['Tatt'].toString().split('/')[0].trim())}',
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    Text(
                                                      'Absent: ${(int.parse(i['Latt'].toString().split('/')[1].trim()) + int.parse(i['Patt'].toString().split('/')[1].trim()) + int.parse(i['Tatt'].toString().split('/')[1].trim())) - (int.parse(i['Latt'].toString().split('/')[0].trim()) + int.parse(i['Patt'].toString().split('/')[0].trim()) + int.parse(i['Tatt'].toString().split('/')[0].trim()))}',
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Image.asset(
                                                i['TotalAttandence'] >= 90
                                                    ? 'assets/logos/happy.gif'
                                                    : i['TotalAttandence'] > 80
                                                        ? 'assets/logos/low happy.gif'
                                                        : i['TotalAttandence'] >
                                                                75
                                                            ? 'assets/logos/low sad.gif'
                                                            : 'assets/logos/sad.gif',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          bunklogic(i),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  double getPercentage(String x) {
    return (int.parse(x.split('/')[0].trim()) /
        int.parse(x.split('/')[1].trim()) *
        100);
  }

  String getTime(String x) {
    var dat = x.split(' ')[0].trim();
    var tim = x.split(' ')[1].trim();
    var ampm = x.split(' ')[2].trim();
    DateTime dt = DateTime(
        int.parse(dat.split('/')[2]),
        int.parse(dat.split('/')[1]),
        int.parse(dat.split('/')[0]),
        int.parse(tim.split(':')[0]) + (ampm == 'PM' ? 12 : 0),
        int.parse(tim.split(':')[1]));
    var diff = (DateTime.now().difference(dt).inMinutes).abs();
    if (diff == 0)
      return 'Just Now';
    else if (diff > 0 && diff < 61)
      return '$diff min ago';
    else if (diff < 1440 && diff > 60)
      return '${dt.difference(DateTime.now()).inHours} hours ago';
    else
      return '${dt.difference(DateTime.now()).inDays} days ago';
  }

  Future<void> getData() async {
    setState(() {
      isLoading = false;
    });
    // Sending a POST request with headers
    const info_url = 'https://iterapi-web.herokuapp.com/info/';
    const attend_url = 'https://iterapi-web.herokuapp.com/attendence/';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var payload = {"user_id": "$regdNo", "password": "$password"};
    const headers = {'Content-Type': 'application/json'};
    var infoResp = await http
        .post(info_url, headers: headers, body: jsonEncode(payload))
        .timeout(
      Duration(seconds: 15),
      onTimeout: () {
        Fluttertoast.showToast(
          msg: "Server Error: Timeout",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('server timeout');
        // getoldData();
        // isLoggedIn = false;
        setState(() {
          noInternet = true;
          //_getCredentials();
          serverTimeout = true;
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        return null;
      },
    );
    if (serverTimeout) {
      sem =
          jsonDecode(prefs.getString('attendence'))['griddata'][0]['stynumber'];
      getCourses(sem);
      return;
    }
    var attendResp = await http.post(attend_url,
        headers: headers, body: jsonEncode(payload));
    // print('info: ${infoResp.statusCode}');
    // print('attend: ${attendResp.statusCode}');
    if (infoResp.statusCode == 200 && attendResp.statusCode == 200) {
      infoData = jsonDecode(infoResp.body);
      attendData = jsonDecode(attendResp.body);
      await prefs.setString('attendence', attendResp.body);
      await prefs.setString('info', infoResp.body);
//      print(attendData);
      name = infoData["detail"][0]['name'];
      branch = infoData['detail'][0]['branchdesc'];
      sem = attendData['griddata'][0]['stynumber'];
      gender = infoData['detail'][0]['gender'];
      print(gender);
      double totatt = 0.0;
      int cnt = 0, totAbs = 0;
      for (var i in attendData['griddata']) {
        totatt += i['TotalAttandence'];
        totAbs += (int.parse(i['Latt'].toString().split('/')[1].trim()) +
                int.parse(i['Patt'].toString().split('/')[1].trim()) +
                int.parse(i['Tatt'].toString().split('/')[1].trim())) -
            (int.parse(i['Latt'].toString().split('/')[0].trim()) +
                int.parse(i['Patt'].toString().split('/')[0].trim()) +
                int.parse(i['Tatt'].toString().split('/')[0].trim()));
        cnt++;
      }
      avgAttend = (totatt / cnt).round();
      avgAbsent = totAbs ~/ cnt;
      // print('$name - $sem');
      getResult();
      getCourses(sem);
      Fluttertoast.showToast(
        msg: "Data Fetched",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      //showToast(context,'Status: ${attendResp.statusCode}');
      setState(() {
        isLoading = false;
        isLoggedIn = true;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Server Error: ${attendResp.statusCode}\nOr Invalid Credentials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('server error');
      isLoggedIn = false;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  getResult() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // String s = prefs.getString('result');
    // resultData = s.substring(1, s.length - 1).split(', ').toList();
    resultData = List();
    // String results = '';
    print('loading results...');
    const result_url = 'https://iterapi-web.herokuapp.com/result/';
    for (int i = sem - 1; i >= 1; i--) {
      var resultPayload = {
        "user_id": "$regdNo",
        "password": "$password",
        "sem": i
      };
      const headers = {'Content-Type': 'application/json'};
      var resultResp = await http.post(result_url,
          headers: headers, body: jsonEncode(resultPayload));
      if (resultResp.statusCode == 200) {
        resultData.add('${resultResp.body}');
      }
    }
    // resultData = jsonDecode(results);
    // print(resultData);
    print('Result Fetching Complete');
    // String s = resultData.toString();
    // print(s);
    // print(s.substring(1, s.length - 2).split(', ').length);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('result', resultData.toString());
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCourses(var semester) async {
    List<Map<String, dynamic>> linkMap = [];
    var response;
    if (semester == 2)
      response = await http.get("https://www.soa.ac.in/2nd-semester");
    else if (semester == 4)
      response = await http.get(
          "https://www.soa.ac.in/btech-4th-semester-online-video-lectures");
    else if (semester == 6)
      response = await http.get(
          "https://www.soa.ac.in/btech-6th-semester-online-video-lectures");
    else
      response = await http.get(
          "https://www.soa.ac.in/btech-8th-semester-online-video-lectures");

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var links = document.getElementsByClassName('Index-page-content');
      for (var link in links) {
        linkMap.add({
          'course': link
              .getElementsByClassName('sqs-block html-block sqs-block-html')[0]
              .text,
          'subjects': [
            for (int i = 0; i < link.querySelectorAll('p').length - 2; i += 3)
              {
                'subject': link.querySelectorAll('p')[i].text,
                'subjectCode': link.querySelectorAll('p')[i + 1].text,
                'link': link
                    .querySelectorAll('p')[i + 2]
                    .querySelector('a')
                    .attributes['href'],
                // 'lectures': await getLectures(link
                //     .querySelectorAll('p')[i + 2]
                //     .querySelector('a')
                //     .attributes['href']),
              }
          ],
        });
      }
    }
    // print(linkMap[0]['subjects']);
    courseData = linkMap;
  }

  getCalender() async {
    String url = "https://www.soa.ac.in/iter";

    final resp1 = await http.get(url);
    if (resp1.statusCode == 200) {
      var doc1 = parse(resp1.body);
      var link1 = url.substring(0, url.lastIndexOf('/')) +
          doc1
              .getElementById('block-yui_3_17_2_1_1576815128904_12538')
              .querySelector('a')
              .attributes['href'];
      // print(link1);
      final resp2 = await http
          .get(link1); //.catchError(() => acedemicCalenderLink = null)
      if (resp2.statusCode == 200) {
        var doc2 = parse(resp2.body);
        var link2 = doc2
            .getElementById('block-8f7f068fc7f6fb6d65aa')
            .querySelector('iframe')
            .attributes['src'];
        acedemicCalenderLink = link2;
      }
    }
  }

  // getCurriculum() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   String url = 'https://www.soa.ac.in/btech-academic-curriculum';
  //   final resp1 = await http.get(url);
  //   if (resp1.statusCode == 200) {
  //     var doc = parse(resp1.body);
  //     var link =
  //         doc.querySelectorAll('main> section> div > div > div> div> div');
  //     for (var i in link) {
  //       var x = i.querySelector('div> div> div> div> a');
  //       if (x != null) {
  //         // print('${x.text} : $branch');
  //         if (x.text.replaceAll('&', 'and') == branch) {
  //           var url2 =
  //               url.substring(0, url.lastIndexOf('/')) + x.attributes['href'];
  //           var resp2 = await http.get(url2);
  //           if (resp2.statusCode == 200) {
  //             var doc2 = parse(resp2.body);
  //             var link2 =
  //                 doc2.querySelectorAll('iframe').last.attributes['src'];
  //             // print(link2);
  //             curriculumLink = link2.substring(0, link2.lastIndexOf('?'));
  //           }

  //           print(curriculumLink);
  //           // break;
  //         }
  //       }
  //     }
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  String bunklogic(var i) {
    var bunkText;
    var absent = (int.parse(i['Latt'].toString().split('/')[1].trim()) +
            int.parse(i['Patt'].toString().split('/')[1].trim()) +
            int.parse(i['Tatt'].toString().split('/')[1].trim())) -
        (int.parse(i['Latt'].toString().split('/')[0].trim()) +
            int.parse(i['Patt'].toString().split('/')[0].trim()) +
            int.parse(i['Tatt'].toString().split('/')[0].trim()));
    var classes = int.parse(i['Latt'].toString().split('/')[1].trim()) +
        int.parse(i['Patt'].toString().split('/')[1].trim()) +
        int.parse(i['Tatt'].toString().split('/')[1].trim());
    var present = classes - absent;
    var totalPercentage = present / classes * 100;
    var bunk = classes - (classes * 0.75).floor() - absent;

    if (bunk > 0) {
      bunkText = 'Bunk ' +
          (classes - (classes * 0.75).floor() - absent).toString() +
          ' more classes to get 75%';
      if (totalPercentage < 80 && totalPercentage > 75)
        bunkText = bunkText +
            '\nAttend ' +
            ((((classes * 0.8) - present) / 0.2).floor()).toString() +
            ' more classes to get 80%';
      if (totalPercentage > 80)
        bunkText = bunkText +
            '\nBunk ' +
            (classes - (classes * 0.8).floor() - absent).toString() +
            ' more classes to get 80%';
      if (totalPercentage < 90 && totalPercentage > 80)
        bunkText = bunkText +
            '\nAttend ' +
            ((((classes * 0.9) - present) / 0.1).floor()).toString() +
            ' more classes to get 90%';
      if (totalPercentage > 90)
        bunkText = bunkText +
            '\nBunk ' +
            (classes - (classes * 0.85).floor() - absent).toString() +
            ' more classes to get 85%';
    } else {
      bunk = (((classes * 0.75) - present) / 0.25).floor();
      if (bunk != 0) {
        bunkText = 'Attend ' + bunk.toString() + ' more classes for 75 %';
        bunk = (((classes * 0.80) - present) / 0.2).floor();
        bunkText =
            bunkText + '\nAttend ' + bunk.toString() + ' more classes for 80 %';
      } else {
        bunk = (((classes * 0.80) - present) / 0.2).floor();
        bunkText = 'Attend ' + bunk.toString() + ' more classes for 80 %';
      }
    }
    return bunkText;
  }

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
              //            backgroundColor: Colors.lightBlueAccent,
              automaticallyImplyLeading: true,
              leading: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => Navigator.pop(context, false)),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('Lectures'),
              onTap: isLoading
                  ? null
                  : !serverTimeout && noInternet
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
                          MaterialPageRoute(builder: (context) => Courses())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Result'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Result())),
            ),
            Divider(),
            ListTile(
              leading: Icon(LineAwesomeIcons.book),
              title: Text('Study Materials'),
              onTap: isLoading
                  ? null
                  : !serverTimeout && noInternet
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
                              builder: (context) => WebPageView(
                                  'ITER Book Shelf',
                                  'https://drive.google.com/drive/folders/1kzQtTLe5RDoU15yulF8_AqsUEpudWkOl?usp=sharing'))),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Notices & News'),
              onTap: isLoading
                  ? null
                  : !serverTimeout && noInternet
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
            Divider(),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Academic Calender'),
              onTap: isLoading
                  ? null
                  : !serverTimeout && noInternet
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
                              builder: (context) => WebPageView(
                                  'Calender', acedemicCalenderLink))),
            ),
            // Divider(),
            // ListTile(
            //     leading: Icon(Icons.assignment_turned_in),
            //     title: Text('Curriculum'),
            //     onTap: isLoading
            //         ? null
            //         : noInternet
            //             ? () {
            //                 Fluttertoast.showToast(
            //                   msg: "No Internet!",
            //                   toastLength: Toast.LENGTH_SHORT,
            //                   gravity: ToastGravity.BOTTOM,
            //                   timeInSecForIosWeb: 2,
            //                   backgroundColor: Colors.redAccent,
            //                   textColor: Colors.white,
            //                   fontSize: 16.0,
            //                 );
            //               }
            //             : () {
            //                 // setState(() {
            //                 //   getCurriculum();
            //                 // });
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) =>
            //                             WebPageView(branch, curriculumLink)));
            //               }),
            Divider(),
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
            Divider(),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Logout'),
              onTap: () => {
                attendData = null,
                resultData = null,
                name = null,
                sem = null,
                infoData = null,
                isLoggedIn = false,
                regdNo = null,
                password = null,
                _resetCredentials(),
                Fluttertoast.showToast(
                  msg: "Logged out!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                ),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()))
              },
            ),
          ],
        ),
      ),
    );
  }
}
