import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iteraio/models/api_provider.dart';
import 'package:iteraio/models/result_model.dart';
import 'package:iteraio/models/session.dart';
import 'package:requests/requests.dart';

class ResultFetch {
  final String regdNo;
  final String password;
  List<CGPASemResult> finalResult;
  // final int sem;

  ResultFetch({
    @required this.regdNo,
    @required this.password,
    // @required this.sem,
  }) {
    _saveFinalResult();
  }

  fetRes() async {
    final request = {
      "username": "1941012408",
      "password": "29Sept00",
      "MemberType": "S"
    };
    const url = "http://136.233.14.3:8282/CampusPortalSOA";
    var cookie = await Session().login(url + '/login', jsonEncode(request));
    // print(d.toString());
    var d2 = await Session().post(url + '/stdrst', jsonEncode({}),
        cookie.substring(0, cookie.indexOf(';')));
    print(d2.toString());

    // var r1 = await Requests.post(
    //     "http://136.233.14.3:8282/CampusPortalSOA/login",
    //     json: request,
    //     headers: {"contentType": "json/application"},
    //     timeoutSeconds: 12);
    // r1.raiseForStatus();
    // print(r1.contentType);

    // // this will re-use the persisted cookies
    // var r2 = await Requests.post(
    //     "http://136.233.14.3:8282/CampusPortalSOA/studentinfo",
    //     json: {});
    // r2.raiseForStatus();
    // // print(r2.json()['id']);
    // print(r2.statusCode);
    // print(r2.content());

    // ApiProvider().login().then((value) => ApiProvider().getStudentInfo());
  }

  void _saveFinalResult() async {
    finalResult = await _fetchResult() as List<CGPASemResult>;
  }

  Future<List<CGPASemResult>> getResult() async {
    if (finalResult != null) {
      return finalResult;
    } else {
      return await _fetchResult();
    }
  }

  Future _fetchResult() async {
    List<CGPASemResult> resultData = [];
    print('loading results on helper...');

    final request = {
      "username": regdNo,
      "password": password,
      "MemberType": "S"
    };
    const url = "http://136.233.14.3:8282/CampusPortalSOA";
    var cookie = await Session().login(url + '/login', jsonEncode(request));

    // const cgpa_url = 'https://iterapi-web.herokuapp.com/cgpa/';
    // var cgpaPayload = {"user_id": "$regdNo", "password": "$password"};
    // const headers = {'Content-Type': 'application/json'};
    // var cgpaResp = await http.post(cgpa_url,
    //     headers: headers, body: jsonEncode(cgpaPayload));
    // if (cgpaResp.statusCode == 200) {
    //   var cgpaData = jsonDecode(cgpaResp.body);
    // print(cgpaResp.toString());

    var cgpaData = await Session().post(url + '/stdrst', jsonEncode({}),
        cookie.substring(0, cookie.indexOf(';')));
    for (var i in cgpaData['data']) {
      resultData.add(CGPASemResult(
        creditEarned: i['totalearnedcredit'],
        sem: i['stynumber'],
        sgpa: i['sgpaR'],
        fail: i['fail'] == "N" ? false : true,
        underHold: i['holdprocessing'] == "N" ? false : true,
        deactive: i['deactive'] == "N" ? false : true,
        details: await _getDetailedResult(i['stynumber']),
      ));
    }
    // print(resultData[0].sem.toString());
    // }

    print('Result Fetching Complete with helper');
    Fluttertoast.showToast(
      msg: "Results Fetched!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.greenAccent,
      textColor: Colors.black,
      fontSize: 16.0,
    );

    return resultData.reversed.toList();
  }

  Future<List<DetailedResult>> _getDetailedResult(int sem) async {
    const result_url = 'https://iterapi-web.herokuapp.com/result/';
    var resultPayload = {
      "user_id": "$regdNo",
      "password": "$password",
      "sem": sem
    };
    const headers = {'Content-Type': 'application/json'};
    var resultResp = await http.post(result_url,
        headers: headers, body: jsonEncode(resultPayload));
    List<DetailedResult> res = [];
    if (resultResp.statusCode == 200) {
      var body = jsonDecode(resultResp.body);
      for (var i in body['Semdata'])
        res.add(DetailedResult(
          sem: i['stynumber'],
          earnedCredit: i['earnedcredit'],
          grade: i['grade'],
          subjectCode: i['subjectcode'],
          subjectName: i['subjectdesc'],
        ));
    }
    return res.toList();
  }
}
