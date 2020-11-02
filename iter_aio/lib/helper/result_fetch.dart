import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/models/result_model.dart';
import 'package:iteraio/helper/session.dart';

class ResultFetch {
  List<CGPASemResult> finalResult;

  ResultFetch() {
    _saveFinalResult();
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

    var cgpaData =
        await Session().post(mainUrl + '/stdrst', jsonEncode({}), cookie);
    // print(cgpaData);
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
    List<DetailedResult> res = [];
    var _url = mainUrl + '/rstdtl';
    var data = jsonEncode({"styno": sem.toString()});

    var body = await Session().post(_url, data, cookie);
    for (var i in body['Semdata'])
      res.add(DetailedResult(
        sem: i['stynumber'],
        earnedCredit: i['earnedcredit'],
        grade: i['grade'],
        subjectCode: i['subjectcode'],
        subjectName: i['subjectdesc'],
      ));
    return res.toList();
  }
}

// fetRes() async {
//   final request = {
//     "username": "1941012408",
//     "password": "29Sept00",
//     "MemberType": "S"
//   };
//   const url = "http://136.233.14.3:8282/CampusPortalSOA";
//   var cookie = await Session().login(url + '/login', jsonEncode(request));
//   // print(d.toString());
//   var d2 = await Session().post(url + '/stdrst', jsonEncode({}),
//       cookie.substring(0, cookie.indexOf(';')));
//   print(d2.toString());
// }
