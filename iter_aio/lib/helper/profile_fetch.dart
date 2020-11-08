import 'dart:convert';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/models/firestore_to_model.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/helper/session.dart';

class ProfileFetch {
  ProfileInfo finalProfile;

  ProfileFetch() {
    _saveFinalProfile();
  }

  void _saveFinalProfile() async {
    try {
      oldpi = await fetchOldProfile();
    } on Exception catch (e) {
      print('$e');
    }
    finalProfile = await _fetchProfile() as ProfileInfo;

    if (finalProfile != null) {
      name = pi.finalProfile.name;
      branch = pi.finalProfile.branchdesc;
      sem = pi.finalProfile.semester;
      gender = pi.finalProfile.gender;
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
    if (isMobile) addProfile(_profileInfo);
    return _profileInfo;
  }

  Future<void> addProfile(ProfileInfo p) {
    return users
        .doc(regdNo)
        .update({
          'fullName': p.name,
          'sem': p.semester,
          'profile': {
            "name": '${p.name}',
            "semester": p.semester,
            "regdno": '${p.regdno}',
            "image": '${p.image == null ? null : p.image.path}',
            "imageUrl": '${p.imageUrl}',
            "sectioncode": '${p.sectioncode}',
            "category": '${p.category}',
            "pincode": p.pincode,
            "gender": '${p.gender}',
            "programdesc": '${p.programdesc}',
            "branchdesc": '${p.branchdesc}',
            "email": '${p.email}',
            "dateofbirth": '${p.dateofbirth}',
            "address": '${p.address}',
            "state": '${p.state}',
            "district": '${p.district}',
            "cityname": '${p.cityname}',
            "nationality": '${p.nationality}',
            "fathername": '${p.fathername}'
          }
        })
        .then((value) => print("Profile Added"))
        .catchError((error) => print("Failed to add Profile: $error"));
  }

  Future<ProfileInfo> fetchOldProfile() {
    return users.doc(regdNo).get().then(
        (value) => FirestoretoModel().profileInfo(value.data()['profile']));
  }
}
