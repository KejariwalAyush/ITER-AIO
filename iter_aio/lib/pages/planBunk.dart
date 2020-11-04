import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/Icons.dart';
import 'package:iteraio/helper/bunk.dart';

class PlanBunk extends StatefulWidget {
  static const routeName = "/plan-bunk";
  @override
  _PlanBunkState createState() => _PlanBunkState();
}

class _PlanBunkState extends State<PlanBunk> {
  var dropdownValue,
      subject,
      subdata,
      subjectCode,
      subatt = 0.0,
      classes = 0,
      absent = 0,
      resText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        centerTitle: true,
        elevation: 15,
        // actions: <Widget>[
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  hint: Text('Select Subject'),
                  onChanged: (String newValue) {
                    setState(() {
                      resText = null;
                      dropdownValue = newValue;
                      for (var i in af.finalAttendance.data) {
                        if (i.subject == dropdownValue) {
                          subject = i.subject;
                          subatt = i.totAtt;
                          subjectCode = i.subjectCode;
                          classes = i.present + i.absent;
                          absent = i.absent;
                          subdata = i.rawData;
                        }
                      }
                    });
                  },
                  items: <String>[
                    for (var i in af.finalAttendance.data) '${i.subject}',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        // style: TextStyle(color: Colors.deepPurple),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              subject == null
                  ? SizedBox(
                      height: 200,
                      child: FlareActor("assets/animations/ITER-AIO.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: "hello"),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          subjectAvatar(subjectCode),
                          width: 70,
                          alignment: Alignment.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text(
                            '$subject',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Absent / Classes : $absent/$classes',
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: subatt > 90
                                  ? Colors.green
                                  : subatt > 80
                                      ? Colors.lightGreen
                                      : subatt > 75
                                          ? Colors.orangeAccent
                                          : Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$subatt %',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              subdata == null
                  ? SizedBox()
                  : Center(
                      child: Text(
                        Bunk().bunklogic(jsonDecode(jsonEncode(subdata))),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              subject == null
                  ? SizedBox()
                  : Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: new BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? colorLight
                                  : colorDark,
                          borderRadius: BorderRadius.circular(15),
                          border: new Border.all(
                            width: 4,
                            style: BorderStyle.solid,
                          )),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    'Enter no. of Classes\nYou want to attend more. '),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      hintText: 'Enter Classes',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      // border: OutlineInputBorder(
                                      //     borderRadius: BorderRadius.circular(32.0)),
                                    ),
                                    onSubmitted: (value) {
                                      // print(value);
                                      setState(() {
                                        resText = Bunk().planBunkLogic(
                                            jsonDecode(jsonEncode(subdata)),
                                            eclasses: int.parse(value));
                                        // resText =
                                        //     Bunk().planBunkLogic(subdata, ebunk: int.parse(value));
                                      });
                                      // print(resText);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Text('OR'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    'Enter no. of Classes\nYou want to BUNK more. '),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      hintText: 'Enter Bunks',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      // border: OutlineInputBorder(
                                      //     borderRadius: BorderRadius.circular(32.0)),
                                    ),
                                    onSubmitted: (value) {
                                      // print(value);
                                      setState(() {
                                        resText = Bunk().planBunkLogic(
                                            jsonDecode(jsonEncode(subdata)),
                                            ebunk: int.parse(value));
                                      });
                                      // print(resText);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Text('OR'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Enter Percentage\nYou want to get. '),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      hintText: 'Enter %',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      // border: OutlineInputBorder(
                                      //     borderRadius: BorderRadius.circular(32.0)),
                                    ),
                                    onSubmitted: (value) {
                                      // print(value);
                                      setState(() {
                                        // print(Bunk().planBunkLogic(subdata,
                                        //     epercent: double.parse(value)));
                                        resText = Bunk().planBunkLogic(
                                            jsonDecode(jsonEncode(subdata)),
                                            epercent: double.parse(value));
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              resText == null
                  ? SizedBox()
                  : Text(
                      '$resText',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
