import 'dart:io';

import 'package:iteraio/models/attendance_info.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/models/result_model.dart';

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

  CGPASemResult cgpaSemResult(var x) {
    CGPASemResult _csr;
    _csr = new CGPASemResult(
      sem: (x['sem']),
      creditEarned: (x['creditEarned']),
      sgpa: (x['sgpa']),
      deactive: x['deactive'] == 'true',
      fail: x['fail'] == 'true',
      underHold: x['underHold'] == 'true',
      details: [for (var i in x['details']) detailedResult(i)],
    );
    return _csr;
  }

  DetailedResult detailedResult(var x) {
    DetailedResult _dr;
    _dr = new DetailedResult(
        sem: (x['sem']),
        earnedCredit: (x['earnedCredit']),
        subjectCode: x['subjectCode'],
        subjectName: x['subjectName'],
        grade: x['grade'],
        subjectShortName: x['subjectShortName']);
    return _dr;
  }

  ProfileInfo profileInfo(var x) {
    ProfileInfo _pi;
    _pi = new ProfileInfo(
        name: x['name'],
        semester: (x['semester']),
        regdno: x['regdno'],
        address: x['address'],
        branchdesc: x['branchdesc'],
        category: x['category'],
        cityname: x['cityname'],
        dateofbirth: x['dateofbirth'],
        district: x['district'],
        email: x['email'],
        fathername: x['fathername'],
        gender: x['gender'],
        nationality: x['nationality'],
        programdesc: x['programdesc'],
        sectioncode: x['sectioncode'],
        state: x['state'],
        image: File(x['image']),
        imageUrl: x['imageUrl'],
        pincode: (x['pincode']));

    return _pi;
  }

  LoginData loginData(var x) {
    LoginData _ld;
    _ld = new LoginData(
      name: x['name'],
      message: x['message'],
      password: x['password'],
      regdNo: x['regdNo'],
      status: x['status'],
      cookie: x['cookie'],
    );
    return _ld;
  }
}
