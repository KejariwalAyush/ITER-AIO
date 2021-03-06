import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/Icons.dart';
import 'package:iteraio/helper/bunk.dart';
import 'package:iteraio/models/attendance_info.dart';
import 'package:iteraio/widgets/large_appdrawer.dart';
import 'package:iteraio/models/firestore_to_model.dart';

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
        leading: MediaQuery.of(context).size.width > 700
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: new Icon(Icons.feedback),
        //     onPressed: () {
        //       Wiredash.of(context).show();
        //     },
        //   ),
        // ],
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(25),
            //     bottomRight: Radius.circular(25))
            ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width > 700)
            LargeAppDrawer().largeDrawer(context),
          Expanded(
            flex: 2,
            child: FutureBuilder<AttendanceInfo>(
                future: users.doc(regdNo).get().then((value) =>
                    FirestoretoModel().attendanceInfo(value['attendance'])),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return buildNoData();
                  else
                    return buildBunk(context);
                }),
          ),
        ],
      ),
    );
  }

  Center buildBunk(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: buildDropdownButton(),
            ),
            SizedBox(
              height: 10,
            ),
            subject == null ? buildflare() : buildSubjectTab(),
            SizedBox(
              height: 10,
            ),
            subdata == null
                ? SizedBox()
                : Center(
                    child: Text(
                      Bunk().bunklogic(jsonDecode((subdata))),
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
                        color: Theme.of(context).brightness == Brightness.light
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
                                          jsonDecode((subdata)),
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
                                          jsonDecode((subdata)),
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
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Center buildNoData() {
    return Center(
        child: Text('Sorry\nYou can\'t plan your bunk now!\nCome back Later',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)));
  }

  Column buildSubjectTab() {
    return Column(
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }

  DropdownButton<String> buildDropdownButton() {
    return DropdownButton<String>(
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
              classes = i.classes;
              absent = i.absent;
              subdata = i.rawData
                  .replaceAll('{', '{"')
                  .replaceAll(': ', '": "')
                  .replaceAll(', ', '", "')
                  .replaceAll('}', '"}');
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
    );
  }

  SizedBox buildflare() {
    return SizedBox(
      height: 200,
      child: FlareActor("assets/animations/ITER-AIO.flr",
          alignment: Alignment.center, fit: BoxFit.contain, animation: "hello"),
    );
  }
}
