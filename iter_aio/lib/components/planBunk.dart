import 'package:flutter/material.dart';
import 'package:iteraio/MyHomePage.dart';

class PlanBunk extends StatefulWidget {
  @override
  _PlanBunkState createState() => _PlanBunkState();
}

class _PlanBunkState extends State<PlanBunk> {
  var dropdownValue,
      subject,
      subdata,
      subatt = 0.0,
      classes = 0,
      absent = 0,
      no = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: DropdownButton<String>(
                value: dropdownValue,
                hint: Text('Select Subject'),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    for (var i in attendData['griddata'])
                      if (i['subject'].toString().split(' ')[0] ==
                          newValue.split(' ')[0]) {
                        subject = i['subject'];
                        subatt = i['TotalAttandence'];
                        classes = int.parse(
                                i['Latt'].toString().split('/')[0].trim()) +
                            int.parse(
                                i['Patt'].toString().split('/')[0].trim()) +
                            int.parse(
                                i['Tatt'].toString().split('/')[0].trim());
                        absent = (int.parse(
                                    i['Latt'].toString().split('/')[1].trim()) +
                                int.parse(
                                    i['Patt'].toString().split('/')[1].trim()) +
                                int.parse(i['Tatt']
                                    .toString()
                                    .split('/')[1]
                                    .trim())) -
                            (int.parse(
                                    i['Latt'].toString().split('/')[0].trim()) +
                                int.parse(
                                    i['Patt'].toString().split('/')[0].trim()) +
                                int.parse(
                                    i['Tatt'].toString().split('/')[0].trim()));
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
                ? SizedBox()
                : ListTile(
                    title: Text(
                      '$subject',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }

  String planBunkLogic(var i) {
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
}
