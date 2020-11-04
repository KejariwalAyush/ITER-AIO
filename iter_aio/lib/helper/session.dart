import 'dart:convert';

import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {};

  Future login(String url, dynamic data) async {
    headers['Content-Type'] = 'application/json';
    http.Response response = await http.post(url, body: data, headers: headers);
    // print(headers);
    if (response.statusCode == 200)
      return response;
    else
      return null;
  }

  Future<Map> post(String url, dynamic data, String cookie) async {
    http.Response response = await http.post(url,
        body: data,
        headers: {'Content-Type': 'application/json', 'Cookie': cookie});

    if (response.statusCode == 200)
      return json.decode(response.body);
    else
      return null;
  }
}
// "Access-Control-Allow-Origin": "*", // Required for CORS support to work
