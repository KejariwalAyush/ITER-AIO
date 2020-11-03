import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/helper/session.dart';

class LoginFetch {
  LoginData finalLogin;
  String regdNo, password;

  LoginFetch({this.regdNo, this.password}) {
    _saveFinalLogin();
  }

  void _saveFinalLogin() async {
    finalLogin = await _fetchLogin() as LoginData;
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
    var _cookie = resp.headers['set-cookie'].toString();
    _cookie = _cookie.toString().substring(0, _cookie.toString().indexOf(';'));
    var _body = jsonDecode(resp.body);
    _loginData = LoginData(regdNo, password, _cookie, _body["message"],
        _body["status"], _body["name"]);

    return _loginData;
  }
}
