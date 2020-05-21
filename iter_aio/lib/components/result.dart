import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:iteraio/MyHomePage.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        elevation: 15,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.share,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: isLoading || resultData == null
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
                              onTap: () => Navigator.pop(context, false),
                              child: RichText(
                                textAlign: TextAlign.end,
                                text: TextSpan(
                                    text: '$name',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black87
                                          : Colors.white,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: '\nRegd. No.:$regdNo',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.black54
                                                    : Colors.white60,
                                          )),
                                      TextSpan(
                                          text: '\nSemester: $sem',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.black54
                                                    : Colors.white60,
                                          )),
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        for (var j in resultData)
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.purple[100]
                                  : Colors.teal[400],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              title: Text(
                                'Semester : ${jsonDecode(j)['Semdata'][0]['stynumber']}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                '${getTotalresult(j)}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                for (var i in jsonDecode(j)['Semdata'])
                                  ListTile(
                                    title: Text(
                                      '${i['subjectdesc']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Text(
                                      '${i['grade']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '${i['subjectcode']}\nEarned Credit : ${i['earnedcredit']}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isThreeLine: true,
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

  double getTotalresult(String x) {
    double res = 0.0, sum = 0.0;
    int cnt = 0;
    for (var i in jsonDecode(x)['Semdata']) {
      if (i['grade'] == 'O')
        sum += 10;
      else if (i['grade'] == 'A')
        sum += 9.5;
      else if (i['grade'] == 'B')
        sum += 8.5;
      else if (i['grade'] == 'C')
        sum += 7.5;
      else if (i['grade'] == 'D')
        sum += 6.5;
      else if (i['grade'] == 'E')
        sum += 5.5;
      else
        sum += 0;
      cnt++;
    }
    res = sum / cnt;
    return res;
  }
}
