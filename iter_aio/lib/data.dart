import 'dart:convert';

import 'package:http/http.dart' as http;

var attendData, infoData;
List resultData;
var name, regdNo, password;
int sem;

Future<void> getData() async {
  // Sending a POST request with headers
  const info_url = 'https://iterapi-web.herokuapp.com/info/';
  const attend_url = 'https://iterapi-web.herokuapp.com/attendence/';

  const payload = {"user_id": "1941012408", "password": "29Sept00"};
  const headers = {'Content-Type': 'application/json'};
  var infoResp =
      await http.post(info_url, headers: headers, body: jsonEncode(payload));
  var attendResp =
      await http.post(attend_url, headers: headers, body: jsonEncode(payload));
  print('info: ${infoResp.statusCode}');
  print('attend: ${attendResp.statusCode}');
  if (infoResp.statusCode == 200 && attendResp.statusCode == 200) {
    infoData = jsonDecode(infoResp.body);
    attendData = jsonDecode(attendResp.body);

    name = infoData["detail"][0]['name'];
    sem = attendData['griddata'][0]['stynumber'];

    print('$name - $sem');
    getResult();
  } else
    print('server error');
}

getResult() async {
  resultData = List();
  List results = List();
  print('loading results...');
  const result_url = 'https://iterapi-web.herokuapp.com/result/';
  for (int i = sem - 1; i >= 1; i--) {
    var resultPayload = {
      "user_id": "1941012408",
      "password": "29Sept00",
      "sem": i
    };
    const headers = {'Content-Type': 'application/json'};
    var resultResp = await http.post(result_url,
        headers: headers, body: jsonEncode(resultPayload));
    print(resultResp.statusCode);
    if (resultResp.statusCode == 200) {
      results.add({'i': '${jsonDecode(resultResp.body)}'});
    }
  }
  resultData = results;
  print(resultData);
}
