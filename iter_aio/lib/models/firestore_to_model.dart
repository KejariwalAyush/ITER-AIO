import 'package:iteraio/models/attendance_info.dart';

class FirestoretoModel {
  FirestoretoModel();

  AttendanceInfo attendanceInfo(var x) {
    AttendanceInfo _ai;
    _ai = new AttendanceInfo(
        attendAvailable: x['attendAvailable'] == "true",
        avgAbsPer: int.parse(x['avgAbsPer'].toString()),
        avgAttPer: double.parse(x['avgAttPer'].toString()),
        data: [for (var item in x['data']) subjectAttendance(item)]);
    return _ai;
  }

  SubjectAttendance subjectAttendance(var x) {
    SubjectAttendance _sa;
    // var x = jsonDecode(data.toString());
    _sa = new SubjectAttendance(
      absent: int.parse(x['absent'].toString()),
      bunkText: x['bunkText'],
      classes: int.parse(x['classes'].toString()),
      latt: x['latt'],
      lattper: double.parse(x['lattper'].toString()),
      patt: x['patt'],
      pattper: double.parse(x['pattper'].toString()),
      tatt: x['tatt'],
      tattper: double.parse(x['tattper'].toString()),
      rawData: x['rawData'],
      lastUpdatedOn: DateTime.parse(x['lastUpdatedOn']),
      sem: int.parse(x['sem'].toString()),
      subject: x['subject'],
      subjectCode: x['subjectCode'],
      totAtt: double.parse(x['totAtt'].toString()),
      present: int.parse(x['present'].toString()),
    );
    return _sa;
  }
}
