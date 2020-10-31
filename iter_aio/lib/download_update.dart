import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

downloadFile(String url, {String filename}) async {
  var httpClient = http.Client();
  var request = new http.Request('GET', Uri.parse(url));
  var response = httpClient.send(request);
  String dir = (await getApplicationDocumentsDirectory()).path;

  List<List<int>> chunks = new List();
  int downloaded = 0;

  response.asStream().listen((http.StreamedResponse r) {
    r.stream.listen((List<int> chunk) {
      // Display percentage of completion
      debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

      chunks.add(chunk);
      downloaded += chunk.length;
    }, onDone: () async {
      // Display percentage of completion
      debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

      // Save the file
      File file = new File('$dir/$filename');
      final Uint8List bytes = Uint8List(r.contentLength);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      await file.writeAsBytes(bytes);
      return;
    });
  });
  if (downloaded != 0) {
    var apkpath =
        (await getApplicationDocumentsDirectory()).path + '/' + 'iteraio.apk';
    File apk = File(apkpath);
    await apk.open().whenComplete(() {
      apk.delete();
      print('APK Deleted');
    });
    // Future.delayed(Duration(minutes: 1)).whenComplete(() => apk.delete());
  }
}
