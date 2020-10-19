import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/components/Icons.dart';

class PlanBunk extends StatefulWidget {
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
                      for (var i in attendData['griddata'])
                        if (i['subject'].toString().split(' ')[0] ==
                            newValue.split(' ')[0]) {
                          subject = i['subject'];
                          subatt = i['TotalAttandence'];
                          subjectCode = i['subjectcode'];
                          classes = int.parse(
                                  i['Latt'].toString().split('/')[1].trim()) +
                              int.parse(
                                  i['Patt'].toString().split('/')[1].trim()) +
                              int.parse(
                                  i['Tatt'].toString().split('/')[1].trim());
                          absent = (int.parse(i['Latt']
                                      .toString()
                                      .split('/')[1]
                                      .trim()) +
                                  int.parse(i['Patt']
                                      .toString()
                                      .split('/')[1]
                                      .trim()) +
                                  int.parse(i['Tatt']
                                      .toString()
                                      .split('/')[1]
                                      .trim())) -
                              (int.parse(i['Latt']
                                      .toString()
                                      .split('/')[0]
                                      .trim()) +
                                  int.parse(i['Patt']
                                      .toString()
                                      .split('/')[0]
                                      .trim()) +
                                  int.parse(i['Tatt']
                                      .toString()
                                      .split('/')[0]
                                      .trim()));
                          subdata = i;
                          break;
                        }
                    });
                  },
                  items: <String>[
                    for (var i in attendData['griddata']) //'${i['subject']}',
                      '${i['subject'].toString().length > 30 ? ('${i['subject'].toString().substring(0, 30)}..') : i['subject']}',
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
                        planBunkLogic(subdata),
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
                                      print(value);
                                      setState(() {
                                        resText = planBunkLogic(subdata,
                                            eclasses: int.parse(value));
                                        // resText =
                                        //     planBunkLogic(subdata, ebunk: int.parse(value));
                                      });
                                      print(resText);
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
                                      print(value);
                                      setState(() {
                                        resText = planBunkLogic(subdata,
                                            ebunk: int.parse(value));
                                      });
                                      print(resText);
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
                                      print(value);
                                      setState(() {
                                        // print(planBunkLogic(subdata,
                                        //     epercent: double.parse(value)));
                                        resText = planBunkLogic(subdata,
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

  String planBunkLogic(var i, {var eclasses, var ebunk, var epercent}) {
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

    if (eclasses != null) {
      classes = classes + eclasses;
    }
    if (ebunk != null) {
      classes = classes + ebunk;
      absent = absent + ebunk;
    }

    var present = classes - absent;
    var totalPercentage = present / classes * 100;
    var bunk = present - (classes * 0.75).floor();

    if (epercent != null) {
      // bunk = present - (classes * (0.75)).floor();
      // bunk = classes * (epercent - totalPercentage) ~/ 100;
      // print(classes);
      // print(present);
      if (epercent >= totalPercentage) {
        var x =
            (((classes * epercent / 100) - present) / (1 - (epercent / 100)))
                .ceil();
        bunkText = 'Attend ${x.abs()} more classes to get $epercent\n'
            'and then Bunk ${((present + x) - ((classes + x) * 0.75).floor()).abs()} to get 75 %';
      } else {
        var x = (present * 100 / epercent).floor() - classes;
        bunkText = 'Bunk ${x.abs()} more classes to get $epercent';
      }
      return bunkText;
    }

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

    if (eclasses != null || ebunk != null) {
      bunkText =
          'Your Total Percentage = ${totalPercentage.toString().split('.')[0]}.${totalPercentage.toString().split('.')[1].substring(0, 1)} %\n'
          'After that: \n$bunkText';
    }

    return bunkText;
  }
}
