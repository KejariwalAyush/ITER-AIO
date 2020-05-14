import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var attendData, infoData;
List resultData;
var name,
    regdNo = '1941012408',
    password = '29Sept00';
int sem;
var isLoading = false;

//var c1 = '0x0e0f3b';
//var c2 = '0x07407b';
//var c3 = '0x7fcdee';
//var c4 = '0xf7931e';
//var c5 = '0xffffff';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      appBar: AppBar(
        title: Text('ITER AIO'),
        elevation: 15,
        actions: <Widget>[
          Icon(Icons.share),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        automaticallyImplyLeading: false,
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
                          child: Icon(Icons.person, size: 60,),
//                                child: Image.asset('male.webp',fit: BoxFit.cover,),
                          radius: 40,
//                                backgroundColor: Colors.purple[100],
                        )),
                    Expanded(
                      flex: 3,
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                            text: '$name',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            children: [
                              TextSpan(
                                  text: '\nRegd. No.:$regdNo',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54)),
                              TextSpan(
                                  text: '\nSemester: $sem',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54)),
                            ]),
                      ),
                    )
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
                          Text('Last Updated On: ${i['lastupdatedon']}'),
                          if (i['Latt'] != '0 / 0')
                            Text(
                              'Theory: \t\t\t${i['Latt']} (${getPercentage(
                                  i['Latt']).floor()}%)',
                              textAlign: TextAlign.justify,
                            ),
                          if (i['Patt'] != '0 / 0')
                            Text(
                              'Practical: \t\t\t${i['Patt']} (${getPercentage(
                                  i['Patt']).floor()}%)',
                              textAlign: TextAlign.justify,
                            ),
                          if (i['Tatt'] != '0 / 0')
                            Text(
                              'Tatt: \t\t\t${i['Tatt']} (${getPercentage(
                                  i['Tatt']).floor()}%)',
                              textAlign: TextAlign.justify,
                            ),
                          Text(
                            'Classes: ${int.parse(
                                i['Latt'].toString().split('/')[0].trim()) +
                                int.parse(
                                    i['Patt'].toString().split('/')[0].trim()) +
                                int.parse(i['Tatt'].toString().split('/')[0]
                                    .trim())}',
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            'Absent: ${(int.parse(
                                i['Latt'].toString().split('/')[1].trim()) +
                                int.parse(
                                    i['Patt'].toString().split('/')[1].trim()) +
                                int.parse(
                                    i['Tatt'].toString().split('/')[1].trim()))
                                - (int.parse(
                                    i['Latt'].toString().split('/')[0].trim()) +
                                    int.parse(i['Patt'].toString().split('/')[0]
                                        .trim()) + int.parse(
                                    i['Tatt'].toString().split('/')[0]
                                        .trim()))}',
                            textAlign: TextAlign.justify,
                          ),
                          Text(bunklogic(i), textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),),
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

  String getColor(double totalPersentage) {
//    int totalPersentage = int.parse(x.split('.')[0]);
    String indicate;
    if (totalPersentage >= 85)
      indicate = 'o';
    else if (totalPersentage >= 75 && totalPersentage < 85)
      indicate = 'a';
    else if (totalPersentage < 75 && totalPersentage >= 65)
      indicate = 'b';
    else
      indicate = 'f';
    return indicate;
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
      sem = attendData['griddata'][0]['stynumber'];

      print('$name - $sem');
      getResult();
      setState(() {
        isLoading = false;
      });
    } else {
      print('server error');
    }
  }

  getResult() async {
//    setState(() {
//      isLoading = true;
//    });
    resultData = List();
    List results = List();
    print('loading results...');
    const result_url = 'https://iterapi-web.herokuapp.com/result/';
    for (int i = sem - 1; i >= 1; i--) {
      var resultPayload = {
        "user_id": "1941012408",
        "password": "29Sept00",
        "sem": i
      };
      const headers = {'Content-Type': 'application/json'};
      var resultResp = await http.post(result_url,
          headers: headers, body: jsonEncode(resultPayload));
      print(resultResp.statusCode);
      if (resultResp.statusCode == 200) {
        results.add({'i': '${jsonDecode(resultResp.body)}'});
      }
    }
    resultData = results;
    print('Result Fetching Complete');
//    setState(() {
//      isLoading = false;
//    });
  }

  String bunklogic(var i) {
    var bunkText;
    var absent = (int.parse(i['Latt'].toString().split('/')[1].trim()) +
        int.parse(i['Patt'].toString().split('/')[1].trim()) +
        int.parse(i['Tatt'].toString().split('/')[1].trim()))
        - (int.parse(i['Latt'].toString().split('/')[0].trim()) +
            int.parse(i['Patt'].toString().split('/')[0].trim()) +
            int.parse(i['Tatt'].toString().split('/')[0].trim()));
    var classes = int.parse(i['Latt'].toString().split('/')[1].trim()) +
        int.parse(i['Patt'].toString().split('/')[1].trim()) +
        int.parse(i['Tatt'].toString().split('/')[1].trim());
    var present = classes - absent;
    var totalPercentage = present / classes * 100;
    var bunk = classes - (classes * 0.75).floor() - absent;

    if (bunk > 0) {
      bunkText =
          'Bunk ' + (classes - (classes * 0.75).floor() - absent).toString() +
              ' more classes to get 75%';
      if (totalPercentage < 80 && totalPercentage > 75)
        bunkText = bunkText + '\nAttend ' +
            ((((classes * 0.8) - present) / 0.2).floor()).toString() +
            ' more classes to get 80%';
      if (totalPercentage > 80)
        bunkText = bunkText + '\nBunk ' +
            (classes - (classes * 0.8).floor() - absent).toString() +
            ' more classes to get 80%';
      if (totalPercentage < 90 && totalPercentage > 80)
        bunkText = bunkText + '\nAttend ' +
            ((((classes * 0.9) - present) / 0.1).floor()).toString() +
            ' more classes to get 90%';
      if (totalPercentage > 90)
        bunkText = bunkText + '\nBunk ' +
            (classes - (classes * 0.85).floor() - absent).toString() +
            ' more classes to get 85%';
    }
    else {
      bunk = (((classes * 0.75) - present) / 0.25).floor();
      bunkText = 'Attend ' + bunk.toString() + ' more classes for 75 %';
      bunk = (((classes * 0.80) - present) / 0.2).floor();
      bunkText =
          bunkText + '\nAttend ' + bunk.toString() + ' more classes for 80 %';
    }
    return bunkText;
  }
}
