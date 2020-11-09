import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/videoPlayer.dart';
import 'package:iteraio/models/lectures_model.dart';
import 'package:iteraio/widgets/large_appdrawer.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LecturesPage extends StatefulWidget {
  static const routeName = "lectures-page";
  final Subject subject;
  LecturesPage({this.subject});
  @override
  _LecturesPageState createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {
  _setLastVideoDetails(String title, String link) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('video title', title);
    await prefs.setString('video link', link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        centerTitle: true,
        elevation: 15,
        leading: MediaQuery.of(context).size.width > 700
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width > 700)
            LargeAppDrawer().largeDrawer(context),
          Expanded(
            flex: 2,
            child: Container(
              child: FutureBuilder(
                future: lf.getLecture(widget.subject),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Container(height: 200, child: loading()),
                    );
                  else
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i in snapshot.data)
                            _buildLectTile(i, context),
                        ],
                      ),
                    );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildLectTile(Lecture i, BuildContext context) {
    return ListTile(
      enabled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        i.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      leading: Icon(Icons.play_circle_filled),
      trailing: Text(
        '${i.size} MB',
        style: TextStyle(
          fontSize: 14,
        ),
      ),
      // subtitle: Text(
      //   DateTime.fromMillisecondsSinceEpoch(i.date).toString(),
      //   style: TextStyle(
      //       color: brightness == Brightness.dark
      //           ? Colors.white60
      //           : Colors.black54),
      // ),
      onTap: //null,
          () {
        _setLastVideoDetails(i.title, i.link2);
        if (kIsWeb ||
            Platform.isWindows ||
            Platform.isLinux ||
            Platform.isMacOS)
          _launchURL(i.link2);
        else
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebPageVideo(i.title, i.link2)));
      },
    );
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
