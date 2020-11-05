import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
    } on Exception catch (e) {
      debugPrint('$e');
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
    http.Response resp =
        await Session().login(mainUrl + '/login', jsonEncode(request));
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
    }
    return _loginData;
  }
}
