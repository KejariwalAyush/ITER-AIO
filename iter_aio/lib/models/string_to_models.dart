import 'dart:convert';
import 'dart:io';

import 'package:iteraio/models/attendance_info.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/models/result_model.dart';

class StringToModel {
  void getAllData(String data) {
    // var x = jsonDecode(data);
  }

  AttendanceInfo attendanceInfo(var data) {
    AttendanceInfo _ai;
    var x = jsonDecode(data.toString());
    print(x);
    _ai = new AttendanceInfo(
        attendAvailable: x['attendAvailable'] == "true",
        avgAbsPer: (x['avgAbsPer']),
        avgAttPer: (x['avgAttPer']),
        data: [for (var item in x['data']) subjectAttendance(item)]);
    return _ai;
  }

  SubjectAttendance subjectAttendance(var data) {
    SubjectAttendance _sa;
    var x = jsonDecode(data.toString());
    _sa = new SubjectAttendance(
      absent: (x['absent']),
      bunkText: x['bunkText'],
      classes: x['classes'],
      latt: x['latt'],
      lattper: (x['lattper']),
      patt: x['patt'],
      pattper: (x['pattper']),
      tatt: x['tatt'],
      tattper: (x['tattper']),
      rawData: x['rawData'],
      lastUpdatedOn: x['lastUpdatedOn'],
      sem: (x['sem']),
      subject: x['subject'],
      subjectCode: x['subjectCode'],
      totAtt: (x['totAtt']),
      present: (x['present']),
    );
    return _sa;
  }

  CGPASemResult cgpaSemResult(var data) {
    CGPASemResult _csr;
    var x = jsonDecode(data.toString());
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

  DetailedResult detailedResult(var data) {
    DetailedResult _dr;
    var x = jsonDecode(data.toString());
    _dr = new DetailedResult(
        sem: (x['sem']),
        earnedCredit: (x['earnedCredit']),
        subjectCode: x['subjectCode'],
        subjectName: x['subjectName'],
        grade: x['grade'],
        subjectShortName: x['subjectShortName']);
    return _dr;
  }

  ProfileInfo profileInfo(var data) {
    ProfileInfo _pi;
    var x = jsonDecode(data.toString());
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

  LoginData loginData(var data) {
    LoginData _ld;
    var x = jsonDecode(data.toString());
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
