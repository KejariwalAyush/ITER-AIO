import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iteraio/courses.dart';
import 'package:iteraio/login.dart';
import 'package:iteraio/result.dart';

import 'package:html/parser.dart';
// import 'package:http/http.dart';

var attendData, infoData;
var resultData, courseData;
var name,
    branch,
    avgAttend,
    avgAbsent,
    regdNo, //= '1941012408',
    password; //= '29Sept00';
int sem;
var isLoading = false;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var c1 = Color(0x0e0f3b);
  var c2 = Color(0x07407b);
  var c3 = Color(0x7fcdee);
  var c4 = Color(0xf7931e);
  var c5 = Color(0xffffff);

  @override
  void initState() {
    setState(() {
//      isLoading = true;
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widgetDrawer(context),
      appBar: AppBar(
        title: Text('ITER AIO'),
        elevation: 15,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(Icons.apps),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: new Icon(Icons.share),
              onPressed: () {},
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: isLoading || attendData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                ),
//                                child: Image.asset('male.webp',fit: BoxFit.cover,),
                                radius: 40,
//                                backgroundColor: Colors.purple[100],
                              )),
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Result())),
                              child: RichText(
                                textAlign: TextAlign.end,
                                text: TextSpan(
                                    text: '$name',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.black87
                                    ),
                                    children: [
                                      TextSpan(
                                          text: '\nRegd. No.:$regdNo',
                                          style: TextStyle(
                                            fontSize: 14,
                                            // color: Colors.black54
                                          )),
                                      TextSpan(
                                          text: '\nSemester: $sem',
                                          style: TextStyle(
                                            fontSize: 14,
                                            // color: Colors.black54
                                          )),
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    Column(
                      children: <Widget>[
                        for (var i in attendData['griddata'])
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              title: Text(
                                '${i['subject']}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${i['TotalAttandence']} %',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Text('Code: ${i['subjectcode']}'),
                              children: <Widget>[
                                Text(
                                    'Last Updated On: ${getTime(i['lastupdatedon'])}'),
                                if (i['Latt'] != '0 / 0')
                                  Text(
                                    'Theory: \t\t\t${i['Latt']} (${getPercentage(i['Latt']).floor()}%)',
                                    textAlign: TextAlign.justify,
                                  ),
                                if (i['Patt'] != '0 / 0')
                                  Text(
                                    'Practical: \t\t\t${i['Patt']} (${getPercentage(i['Patt']).floor()}%)',
                                    textAlign: TextAlign.justify,
                                  ),
                                if (i['Tatt'] != '0 / 0')
                                  Text(
                                    'Tatt: \t\t\t${i['Tatt']} (${getPercentage(i['Tatt']).floor()}%)',
                                    textAlign: TextAlign.justify,
                                  ),
                                Text(
                                  'Classes: ${int.parse(i['Latt'].toString().split('/')[0].trim()) + int.parse(i['Patt'].toString().split('/')[0].trim()) + int.parse(i['Tatt'].toString().split('/')[0].trim())}',
                                  textAlign: TextAlign.justify,
                                ),
                                Text(
                                  'Absent: ${(int.parse(i['Latt'].toString().split('/')[1].trim()) + int.parse(i['Patt'].toString().split('/')[1].trim()) + int.parse(i['Tatt'].toString().split('/')[1].trim())) - (int.parse(i['Latt'].toString().split('/')[0].trim()) + int.parse(i['Patt'].toString().split('/')[0].trim()) + int.parse(i['Tatt'].toString().split('/')[0].trim()))}',
                                  textAlign: TextAlign.justify,
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
    );
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

    var payload = {"user_id": "$regdNo", "password": "$password"};
    const headers = {'Content-Type': 'application/json'};
    var infoResp =
        await http.post(info_url, headers: headers, body: jsonEncode(payload));
    var attendResp = await http.post(attend_url,
        headers: headers, body: jsonEncode(payload));
    print('info: ${infoResp.statusCode}');
    print('attend: ${attendResp.statusCode}');
    if (infoResp.statusCode == 200 && attendResp.statusCode == 200) {
      infoData = jsonDecode(infoResp.body);
      attendData = jsonDecode(attendResp.body);
//      print(attendData);
      name = infoData["detail"][0]['name'];
      branch = infoData['detail'][0]['branchdesc'];
      sem = attendData['griddata'][0]['stynumber'];
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
      print('$name - $sem');
      getResult();
      getCourses();
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  getResult() async {
//    setState(() {
//      isLoading = true;
//    });
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
      print(resultResp.statusCode);
      if (resultResp.statusCode == 200) {
        resultData.add('${resultResp.body}');
      }
    }
    // resultData = jsonDecode(results);
    // print(resultData);
    print('Result Fetching Complete');
//    setState(() {
//      isLoading = false;
//    });
  }

  Future<void> getCourses() async {
    List<Map<String, dynamic>> linkMap = [];
    final response = await http.get("https://www.soa.ac.in/2nd-semester");
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
                  : () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Courses())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Result'),
              onTap: isLoading
                  ? null
                  : () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Result())),
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
                    MaterialPageRoute(builder: (context) => LoginPage()))
              },
            ),
          ],
        ),
      ),
    );
  }
}
