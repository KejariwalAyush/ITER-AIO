import 'package:flutter/material.dart';
import 'package:iteraio/components/Icons.dart';
import 'package:iteraio/components/lectures.dart';
import 'package:iteraio/Themes/Theme.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/components/videoPlayer.dart';
import 'package:iteraio/main.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  String videoTitle;
  String videoLink;

  void initState() {
    setState(() {
      _getLastVideoDetails();
    });
    super.initState();
  }

  _getLastVideoDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      videoTitle = prefs.getString('video title');
      videoLink = prefs.getString('video link');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        centerTitle: true,
        elevation: 15,
        // actions: <Widget>[
        //   IconButton(
        //     icon: new Icon(Icons.feedback),
        //     onPressed: () {
        //       Wiredash.of(context).show();
        //     },
        //   ),
        // ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      floatingActionButton: videoTitle == null
          ? SizedBox()
          : FloatingActionButton(
              tooltip: 'Play Last Video',
              child: Icon(
                LineAwesomeIcons.play,
                size: 35,
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.grey,
              ),
              backgroundColor: themeDark,
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WebPageVideo(videoTitle, videoLink)),
                  )),
      body: isLoading || courseData == null
          ? Center(
              child: Container(height: 200, child: loading()),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (var i in courseData)
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? colorLight
                            : colorDark,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: false,
                        title: Text(
                          i['course'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        children: <Widget>[
                          for (var j in i['subjects'])
                            ListTile(
                              contentPadding:
                                  EdgeInsets.only(top: 5, left: 30, right: 15),
                              title: Text(
                                j['subject'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                j['subjectCode'],
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Image.asset(
                                subjectAvatar(j['subjectCode']),
                                width: 40,
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Lectures(j['subject'], j['link']))),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
