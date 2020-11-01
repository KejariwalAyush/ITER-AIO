import 'dart:io';

import 'package:flutter/foundation.dart';

class ProfileInfo {
  final String name;
  final File image;
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

  ProfileInfo(
      {@required this.name,
      @required this.semester,
      @required this.regdno,
      this.image,
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
}
