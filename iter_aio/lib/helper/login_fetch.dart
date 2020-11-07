import 'dart:convert';

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

  LoginFetch({this.regdNo, this.password}) {
    _saveFinalLogin();
  }

  void _saveFinalLogin() async {
    try {
      finalLogin = await _fetchLogin() as LoginData;
      // print(finalLogin.toString());
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
}
