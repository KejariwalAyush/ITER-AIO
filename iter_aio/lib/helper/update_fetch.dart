import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info/package_info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateFetch {
  UpdateFetch();

  showUpdateDialog(BuildContext _cxt) {
    Alert(
      context: _cxt,
      type: AlertType.none,
      style: AlertStyle(
        descStyle: TextStyle(
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        titleStyle: TextStyle(
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),
      title: "UPDATE Available!",
      desc: "Version: $latestversion\n$updateText.",
      buttons: [
        DialogButton(
          child: Text(
            "UPDATE",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            _launchURL(updatelink);
            // final appdir = await syspath.getApplicationDocumentsDirectory();
            // await downloadFile(updatelink, filename: 'iteraio.apk');
          },
          // onPressed: () => {},
          color: Color(0xFF333366),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(_cxt),
          color: Colors.blueGrey,
        )
      ],
    ).show();
  }

  fetchupdate(BuildContext context) async {
    // setState(() {
    //   isLoading = true;
    // });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    final Response response =
        await get('https://github.com/KejariwalAyush/ITER-AIO/releases/latest');
    if (response.statusCode == 200) {
      var document = parse(response.body);
      updateText = document.querySelector('div.markdown-body').text;
      // print(updateText);
      List links = document.querySelectorAll('div > ul > li > a > span ');
      List<Map<String, String>> linkMap = [];
      for (var link in links) {
        linkMap.add({
          'title': link.text,
        });
      }
      var dec = jsonDecode(json.encode(linkMap));
      latestversion = dec[6]['title'];

      List links2 = document.querySelectorAll('details > div > div > div > a');
      List<Map<String, String>> linkMap2 = [];
      for (var link in links2) {
        linkMap2.add({
          'title': 'https://github.com' + link.attributes['href'],
        });
      }
      var dec2 = jsonDecode(json.encode(linkMap2));
      updatelink = dec2[0]['title'];
      // print(updatelink);

      if (version.compareTo(latestversion) != 0) {
        print('update available');
        isUpdateAvailable = true;
        showSimpleNotification(
          Text(
            "Update available version: $latestversion",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.black,
          autoDismiss: false,
          leading: Icon(
            Icons.upgrade_rounded,
            color: Colors.white,
          ),
          slideDismiss: true,
          position: NotificationPosition.bottom,
          trailing: Builder(builder: (context) {
            return FlatButton(
                textColor: Colors.yellow,
                onPressed: () => {
                      _launchURL(updatelink),
                    },
                child: Text('UPDATE'));
          }),
        );
        // Alert is in the getData fuction in homePage
      } else {
        // print('Up-to-Date');
        isUpdateAvailable = false;
      }
      // setState(() {
      //   isLoading = false;
      // });
    } else {
      throw Exception('Failed to load');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return;
  }
}
