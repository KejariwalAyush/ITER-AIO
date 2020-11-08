import 'dart:convert';

import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/models/firestore_to_model.dart';
import 'package:iteraio/models/result_model.dart';
import 'package:iteraio/helper/session.dart';

class ResultFetch {
  List<CGPASemResult> finalResult;

  ResultFetch() {
    _saveFinalResult();
  }

  void _saveFinalResult() async {
    try {
      oldres = await fetchOldResult();
    } on Exception catch (e) {
      print('$e');
    }
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
    if (cgpaData != null) {
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
      // Fluttertoast.showToast(
      //   msg: "Results Fetched!",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 2,
      //   backgroundColor: Colors.greenAccent,
      //   textColor: Colors.black,
      //   fontSize: 16.0,
      // );
    }
    if (isMobile) addResult(resultData.reversed.toList());
    return resultData.reversed.toList();
  }

  Future<List<DetailedResult>> _getDetailedResult(int sem) async {
    List<DetailedResult> res = [];
    var _url = mainUrl + '/rstdtl';
    var data = jsonEncode({"styno": sem.toString()});

    var body = await Session().post(_url, data, cookie);
    if (body != null)
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

  Future<void> addResult(List<CGPASemResult> list) {
    return users
        .doc(regdNo)
        .update({
          "result": [
            for (var a in list)
              {
                "sem": a.sem,
                "sgpa": a.sgpa,
                "creditsearned": a.creditEarned,
                "fail": a.fail == true,
                "underHold": a.underHold == true,
                "deactive": a.deactive == true,
                "details": [
                  for (var i in a.details)
                    {
                      "sem": i.sem,
                      "subjectCode": "${i.subjectCode}",
                      "subjectName": "${i.subjectName}",
                      "subjectShortName": "${i.subjectShortName}",
                      "earnedCredit": i.earnedCredit,
                      "grade": "${i.grade}"
                    }
                ]
              }
          ]
        })
        .then((value) => print("Profile Added"))
        .catchError((error) => print("Failed to add Result: $error"));
  }

  Future<List<CGPASemResult>> fetchOldResult() {
    return users.doc(regdNo).get().then((value) {
      List<CGPASemResult> list = [];
      for (var item in value.data()['result'])
        list.add(FirestoretoModel().cgpaSemResult(item));
      return list;
    });
  }
}
