import 'dart:convert';

import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {};

  Future login(String url, dynamic data) async {
    headers['Content-Type'] = 'application/json';
    http.Response response = await http.post(url, body: data, headers: headers);
    // print(headers);
    return response.headers['set-cookie'].toString();
  }

  Future<Map> post(String url, dynamic data, String cookie) async {
    http.Response response = await http.post(url,
        body: data,
        headers: {'Content-Type': 'application/json', 'Cookie': cookie});
    return json.decode(response.body);
  }
}
