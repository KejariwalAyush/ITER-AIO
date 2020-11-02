import 'dart:convert';

import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {};

  Future<Map> get(String url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future login(String url, dynamic data) async {
    headers['Content-Type'] = 'application/json';
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    print(headers);
    return response.headers['set-cookie'].toString();
  }

  Future<Map> post(String url, dynamic data, String cookie) async {
    http.Response response = await http.post(url,
        body: data,
        headers: {'Content-Type': 'application/json', 'Cookie': cookie});
    // updateCookie(response)
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    // print('update $rawCookie');
    // print(response.headers['set-cookie']);
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['Cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
      // print('onset ' + headers['cookie']);
    }
  }
}
