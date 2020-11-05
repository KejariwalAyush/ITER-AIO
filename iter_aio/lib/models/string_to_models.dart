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
    var x = jsonDecode(json.encode(data.toString()));
    print(x);
    _ai = new AttendanceInfo(
        attendAvailable: x['attendAvailable'] == "true",
        avgAbsPer: int.parse(x['avgAbsPer']),
        avgAttPer: double.parse(x['avgAttPer']),
        data: [for (var item in x['data']) subjectAttendance(item)]);
    return _ai;
  }

  SubjectAttendance subjectAttendance(var data) {
    SubjectAttendance _sa;
    var x = jsonDecode(json.encode(data.toString()));
    _sa = new SubjectAttendance(
      absent: int.parse(x['absent']),
      bunkText: x['bunkText'],
      classes: x['classes'],
      latt: x['latt'],
      lattper: double.parse(x['lattper']),
      patt: x['patt'],
      pattper: double.parse(x['pattper']),
      tatt: x['tatt'],
      tattper: double.parse(x['tattper']),
      rawData: x['rawData'],
      lastUpdatedOn: x['lastUpdatedOn'],
      sem: int.parse(x['sem']),
      subject: x['subject'],
      subjectCode: x['subjectCode'],
      totAtt: double.parse(x['totAtt']),
      present: int.parse(x['present']),
    );
    return _sa;
  }

  CGPASemResult cgpaSemResult(var data) {
    CGPASemResult _csr;
    var x = jsonDecode(json.encode(data.toString()));
    _csr = new CGPASemResult(
      sem: int.parse(x['sem']),
      creditEarned: int.parse(x['creditEarned']),
      sgpa: double.parse(x['sgpa']),
      deactive: x['deactive'] == 'true',
      fail: x['fail'] == 'true',
      underHold: x['underHold'] == 'true',
      details: [for (var i in x['details']) detailedResult(i)],
    );
    return _csr;
  }

  DetailedResult detailedResult(var data) {
    DetailedResult _dr;
    var x = jsonDecode(json.encode(data.toString()));
    _dr = new DetailedResult(
        sem: int.parse(x['sem']),
        earnedCredit: int.parse(x['earnedCredit']),
        subjectCode: x['subjectCode'],
        subjectName: x['subjectName'],
        grade: x['grade'],
        subjectShortName: x['subjectShortName']);
    return _dr;
  }

  ProfileInfo profileInfo(var data) {
    ProfileInfo _pi;
    var x = jsonDecode(json.encode(data.toString()));
    _pi = new ProfileInfo(
        name: x['name'],
        semester: int.parse(x['semester']),
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
        pincode: int.parse(x['pincode']));

    return _pi;
  }

  LoginData loginData(var data) {
    LoginData _ld;
    var x = jsonDecode(json.encode(data.toString()));
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
