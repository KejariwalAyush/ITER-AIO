import 'dart:io';

import 'package:flutter/foundation.dart';

class ProfileInfo {
  final String name;
  final File image;
  final String imageUrl;
  final String category;
  final int semester;
  final String gender;
  final String programdesc;
  final String branchdesc;
  final String email;
  final String regdno;
  final String dateofbirth;
  final String address;
  final String state;
  final String district;
  final String cityname;
  final int pincode;
  final String nationality;
  final String fathername;
  final String sectioncode;

  ProfileInfo(
      {@required this.name,
      @required this.semester,
      @required this.regdno,
      this.image,
      this.imageUrl,
      this.sectioncode,
      this.category,
      this.pincode,
      this.gender,
      this.programdesc,
      this.branchdesc,
      this.email,
      this.dateofbirth,
      this.address,
      this.state,
      this.district,
      this.cityname,
      this.nationality,
      this.fathername});

  String toString() {
    var s = '''{
      "name": "$name",
      "semester": $semester,
      "regdno": "$regdno",
      "image": "${image == null ? null : image.path}",
      "imageUrl": "$imageUrl",
      "sectioncode": "$sectioncode",
      "category": "$category",
      "pincode": $pincode,
      "gender": "$gender",
      "programdesc": "$programdesc",
      "branchdesc": "$branchdesc",
      "email": "$email",
      "dateofbirth": "$dateofbirth",
      "address": "$address",
      "state": "$state",
      "district": "$district",
      "cityname": "$cityname",
      "nationality": "$nationality",
      "fathername": "$fathername"}
    ''';
    return s;
  }
}
