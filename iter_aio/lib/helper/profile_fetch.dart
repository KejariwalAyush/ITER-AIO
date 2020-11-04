import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/helper/session.dart';

class ProfileFetch {
  ProfileInfo finalProfile;

  ProfileFetch() {
    _saveFinalProfile();
  }

  void _saveFinalProfile() async {
    finalProfile = await _fetchProfile() as ProfileInfo;

    try {
      name = pi.finalProfile.name;
      branch = pi.finalProfile.branchdesc;
      sem = pi.finalProfile.semester;
      gender = pi.finalProfile.gender;
    } on Exception catch (e) {
      debugPrint('Exception: $e');
    }
  }

  Future<ProfileInfo> getProfile() async {
    if (finalProfile != null) {
      return finalProfile;
    } else {
      return await _fetchProfile();
    }
  }

  Future _fetchProfile() async {
    ProfileInfo _profileInfo;

    var pd =
        await Session().post(mainUrl + '/studentinfo', jsonEncode({}), cookie);
    if (pd != null) {
      var detail = pd['detail'][0];
      if (detail != null)
        _profileInfo = ProfileInfo(
          name: detail['name'],
          semester: detail['stynumber'],
          regdno: detail['enrollmentno'],
          address: detail['paddress1'] +
              '\n' +
              detail['paddress2'] +
              ', ' +
              detail['paddress3'],
          cityname: detail['ccityname'],
          district: detail['cdistrict'],
          state: detail['cstatename'],
          gender: detail['gender'],
          category: detail['category'],
          branchdesc: detail['branchdesc'],
          dateofbirth: detail['dateofbirth'],
          nationality: detail['nationality'],
          email: detail['semailid'],
          fathername: detail['fathersname'],
          pincode: detail['cpin'],
          programdesc: detail['programdesc'],
          sectioncode: detail['sectioncode'],
        );
    }
    // print(pd);

    return _profileInfo;
  }
}

// {
//     "detail": [
//         {
//             "mothersname": "MADHU KEJARIWAL",
//             "cdistrict": "SUNDERGARH",
//             "academicyear": "1920",
//             "gender": "M",
//             "cstatename": "Odisha",
//             "scellno": null,
//             "admissionyear": "1920",
//             "ccityname": "ROURKELA",
//             "ppin": 769004,
//             "programdesc": "Bachelor of Technology",
//             "pdistrict": "SUNDERGARH",
//             "sectioncode": "CSE-D",
//             "enrollmentno": "1941012408",
//             "parentoccupation": null,
//             "branchdesc": "Computer Science and Engineering",
//             "ptelephoneno": "9437082564",
//             "dateofbirth": "29/09/2000",
//             "semailid": "rejayush29@gmail.com",
//             "paddress1": "GANESH KEJARIWAL",
//             "paddress2": "KK-27",
//             "paddress3": "CIVIL TOWNSHIP",
//             "pemailid": "rejayush29@gmail.com",
//             "pcityname": "ROURKELA",
//             "stelephoneno": "9437082564",
//             "stynumber": 2,
//             "caddress3": "CIVIL TOWNSHIP",
//             "bloodgroup": "None",
//             "caddress1": "GANESH KEJARIWAL",
//             "caddress2": "KK-27",
//             "nationality": "INDIAN",
//             "maritalstatus": null,
//             "pstatename": "Odisha",
//             "fathersname": "GANESH KEJARIWAL",
//             "accountno": null,
//             "name": "AYUSH KEJARIWAL",
//             "pcellno": null,
//             "bankname": null,
//             "category": "General",
//             "cpin": 769004
//         }
//     ],
//     "griddata": [
//         {
//             "passingyear": 2016,
//             "division": null,
//             "qualification": "Matric",
//             "percentageofmarks": 79.83,
//             "grade": null,
//             "marksobtained": 479,
//             "maxmarks": 600,
//             "boardname": "ICSE"
//         },
//         {
//             "passingyear": 2018,
//             "division": null,
//             "qualification": "Senior Secondary",
//             "percentageofmarks": 71.4,
//             "grade": null,
//             "marksobtained": 357,
//             "maxmarks": 500,
//             "boardname": "CBSE"
//         }
//     ]
// }
