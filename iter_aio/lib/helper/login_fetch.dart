import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/helper/session.dart';

class LoginFetch {
  LoginData finalLogin;
  String regdNo, password;
  UserCredential userCredential;

  LoginFetch({this.regdNo, this.password}) {
    _saveFinalLogin();
  }

  void _saveFinalLogin() async {
    try {
      finalLogin = await _fetchLogin() as LoginData;
    } on Exception catch (e) {
      debugPrint('On Save Exception: $e');
    }
  }

  Future<LoginData> getLogin() async {
    if (finalLogin != null) {
      return finalLogin;
    } else {
      return await _fetchLogin();
    }
  }

  Future _fetchLogin() async {
    LoginData _loginData;
    final request = {
      "username": regdNo,
      "password": password,
      "MemberType": "S"
    };

    http.Response resp;

    try {
      resp = await Session().login(mainUrl + '/login', jsonEncode(request));

      // print(resp.statusCode);
      if (resp.statusCode == 200) {
        if (isMobile) await firebaseAuth();

        var _cookie = resp.headers['set-cookie'].toString();
        _cookie =
            _cookie.toString().substring(0, _cookie.toString().indexOf(';'));
        var _body = jsonDecode(resp.body);
        _loginData = LoginData(
            regdNo: regdNo,
            password: password,
            cookie: _cookie,
            message: _body["message"],
            status: _body["status"],
            name: _body["name"]);
        return _loginData;
      }
    } on Exception catch (e) {
      serverError = true;
      print(e);
      if (isMobile)
        Fluttertoast.showToast(
            msg: 'Sever Login Error!',
            backgroundColor: Colors.red,
            gravity: ToastGravity.BOTTOM);
      return LoginData(status: 'Error Logging In');
    }
  }

  Future firebaseAuth() async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "$regdNo@iteraio.com", password: password);
      admin = await users.doc(regdNo).get().then((value) => value['admin']);
      print('admin: $admin');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: "$regdNo@iteraio.com", password: password);
          setUser();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
      } else if (e.code == 'wrong-password') {
        try {
          await FirebaseAuth.instance
              .confirmPasswordReset(code: null, newPassword: password);
          print('Password Updated!');
        } on FirebaseException catch (e) {
          print(e.code);
        }
        print('Wrong password provided for that user.');
      }
    }
  }

  void setUser() {
    users
        .doc(regdNo)
        .set({
          'regdNo': regdNo,
          'fullName': '',
          'sem': 2,
          'fcmToken': '',
          'imgUrl': '',
          'emailId': '',
          'clubsRequested': [],
          'admin': false,
          'profile': {
            "name": '',
            "semester": 0,
            "regdno": '',
            "image": '',
            "imageUrl": '',
            "sectioncode": '',
            "category": '',
            "pincode": 0,
            "gender": '',
            "programdesc": '',
            "branchdesc": '',
            "email": '',
            "dateofbirth": '',
            "address": '',
            "state": '',
            "district": '',
            "cityname": '',
            "nationality": '',
            "fathername": ''
          },
          'attendance': {
            "data": [
              {
                "rawData": "",
                "sem": 0,
                "bunkText": "",
                "classes": 0,
                "present": 0,
                "absent": 0,
                "totAtt": 0,
                "latt": "",
                "patt": "",
                "tatt": "",
                "lattper": 0,
                "pattper": 0,
                "tattper": 0,
                "subject": "",
                "subjectCode": "",
                "lastUpdatedOn": ""
              }
            ],
            "avgAttPer": 0,
            "avgAbsPer": 0,
            "attendAvailable": false
          },
          'result': [
            {
              "sem": 0,
              "sgpa": 0,
              "creditsearned": 0,
              "fail": false,
              "underHold": false,
              "deactive": false,
              "details": [
                {
                  "sem": 0,
                  "subjectCode": "",
                  "subjectName": "",
                  "subjectShortName": "",
                  "earnedCredit": 0,
                  "grade": ""
                }
              ]
            }
          ],
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
