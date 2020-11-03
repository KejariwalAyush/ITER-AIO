import 'dart:convert';

import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/helper/bunk.dart';
import 'package:iteraio/helper/session.dart';
import 'package:iteraio/models/attendance_info.dart';

class AttendanceFetch {
  AttendanceInfo finalAttendance;

  AttendanceFetch() {
    _saveFinalAttendance();
  }

  void _saveFinalAttendance() async {
    finalAttendance = await _fetchAttendance() as AttendanceInfo;
  }

  Future<AttendanceInfo> getAttendance() async {
    // print(finalAttendance.data);
    if (finalAttendance != null) {
      return finalAttendance;
    } else
      return await _fetchAttendance();
  }

  Future _fetchAttendance() async {
    AttendanceInfo _attendanceInfo;

    var initbody = await Session()
        .post(mainUrl + '/attendanceinfo', jsonEncode({}), cookie);

    if (initbody != null) {
      String req = initbody['reglov'].toString();
      req = req.substring(1, req.indexOf(':'));
      var body = await Session().post(mainUrl + '/attendanceinfo',
          jsonEncode({"registerationid": req}), cookie);

      if (body != null) {
        _attendanceInfo = AttendanceInfo(
          data: _fetchSubjectAtt(body),
          avgAttPer: _avgAttendence(body),
          avgAbsPer: _avgAbsent(body),
        );
      }
    }

    return _attendanceInfo;
  }

  List<SubjectAttendance> _fetchSubjectAtt(var body) {
    List<SubjectAttendance> sa = [];
    for (var item in body['griddata']) {
      String _bunkText = Bunk().bunklogic(item);
      sa.add(SubjectAttendance(
          sem: item['stynumber'],
          present: _getPresent(item),
          absent: _getAbsent(item),
          lattper: item['Latt'] == 'Not Applicable'
              ? 0.0
              : _getPercentage(item['Latt']),
          pattper: item['Patt'] == 'Not Applicable'
              ? 0.0
              : _getPercentage(item['Patt']),
          tattper: item['Tatt'] == 'Not Applicable'
              ? 0.0
              : _getPercentage(item['Tatt']),
          latt: item['Latt'] == 'Not Applicable' ? '0/0' : item['Latt'],
          patt: item['Patt'] == 'Not Applicable' ? '0/0' : item['Patt'],
          tatt: item['Tatt'] == 'Not Applicable' ? '0/0' : item['Tatt'],
          subject: item['subject'],
          subjectCode: item['subjectcode'],
          totAtt: item['TotalAttandence'],
          bunkText: _bunkText,
          lastUpdatedOn: _getDateTime(item['lastupdatedon'])));
    }
    return sa.toList();
  }

  DateTime _getDateTime(String x) {
    var dat = x.split(' ')[0].trim();
    var tim = x.split(' ')[1].trim();
    var ampm = x.split(' ')[2].trim();
    DateTime dt = DateTime(
        int.parse(dat.split('/')[2]),
        int.parse(dat.split('/')[1]),
        int.parse(dat.split('/')[0]),
        int.parse(tim.split(':')[0]) + (ampm == 'PM' ? 12 : 0),
        int.parse(tim.split(':')[1]));
    return dt;
  }

  double _getPercentage(String x) {
    return (int.parse(x.split('/')[0].trim()) /
        int.parse(x.split('/')[1].trim()) *
        100);
  }

  int _getPresent(var i) {
    int latttot, patttot, tatttot, lattpr, pattpr, tattpr;
    if (i['Latt'] != 'Not Applicable') {
      latttot = int.parse(i['Latt'].toString().split('/')[1].trim());
      lattpr = int.parse(i['Latt'].toString().split('/')[0].trim());
    } else {
      latttot = 0;
      lattpr = 0;
    }
    if (i['Patt'] != 'Not Applicable') {
      patttot = int.parse(i['Patt'].toString().split('/')[1].trim());
      pattpr = int.parse(i['Patt'].toString().split('/')[0].trim());
    } else {
      patttot = 0;
      pattpr = 0;
    }
    if (i['Tatt'] != 'Not Applicable') {
      tatttot = int.parse(i['Tatt'].toString().split('/')[1].trim());
      tattpr = int.parse(i['Tatt'].toString().split('/')[0].trim());
    } else {
      tatttot = 0;
      tattpr = 0;
    }
    var absent = (latttot + patttot + tatttot) - (lattpr + pattpr + tattpr);
    var classes = (latttot + patttot + tatttot);
    var present = classes - absent;
    return present;
  }

  int _getAbsent(var i) {
    int latttot, patttot, tatttot, lattpr, pattpr, tattpr;
    if (i['Latt'] != 'Not Applicable') {
      latttot = int.parse(i['Latt'].toString().split('/')[1].trim());
      lattpr = int.parse(i['Latt'].toString().split('/')[0].trim());
    } else {
      latttot = 0;
      lattpr = 0;
    }
    if (i['Patt'] != 'Not Applicable') {
      patttot = int.parse(i['Patt'].toString().split('/')[1].trim());
      pattpr = int.parse(i['Patt'].toString().split('/')[0].trim());
    } else {
      patttot = 0;
      pattpr = 0;
    }
    if (i['Tatt'] != 'Not Applicable') {
      tatttot = int.parse(i['Tatt'].toString().split('/')[1].trim());
      tattpr = int.parse(i['Tatt'].toString().split('/')[0].trim());
    } else {
      tatttot = 0;
      tattpr = 0;
    }
    var absent = (latttot + patttot + tatttot) - (lattpr + pattpr + tattpr);
    return absent;
  }

  double _avgAttendence(var i) {
    double totatt = 0;
    int sub = 0;
    for (var it in i['griddata']) {
      totatt += it['TotalAttandence'];
      sub++;
    }
    return (totatt / sub * 100).round() / 100;
  }

  int _avgAbsent(var i) {
    int totper = 0;
    int sub = 0;
    for (var it in i['griddata']) {
      totper += _getAbsent(it);
      sub++;
    }
    return (totper / sub).round();
  }
}
