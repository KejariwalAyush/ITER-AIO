import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/components/Icons.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/components/videoPlayer.dart';
import 'package:iteraio/models/lectures_model.dart';
import 'package:iteraio/pages/lectures_page.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesPage extends StatefulWidget {
  static const routeName = "/course-page";
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
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

  bool showLectures = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO - Lectures'),
        centerTitle: true,
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildFloatingButton(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            if (!showLectures)
              Center(
                child: Text(
                  'Semester: $sem',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: lf.getCourse(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Container(height: 200, child: loading()),
                    );
                  else
                    return Column(
                      children: [
                        for (var data in snapshot.data)
                          _buildCourseTile(context, data),
                      ],
                    );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseTile(BuildContext context, CourseLectures cl) {
    return Container(
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
          cl.course,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        children: <Widget>[
          for (var j in cl.subjects)
            ListTile(
              contentPadding: EdgeInsets.only(top: 5, left: 30, right: 15),
              title: Text(
                j.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                j.code,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              trailing: Image.asset(
                subjectAvatar(j.code),
                width: 40,
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LecturesPage(subject: j))),
            ),
        ],
      ),
    );
  }

  Widget buildFloatingButton() {
    return videoTitle == null
        ? SizedBox()
        : FloatingActionButton.extended(
            icon: Icon(
              LineAwesomeIcons.play,
            ),
            foregroundColor:
                brightness == Brightness.dark || themeDark == themeDark1
                    ? Colors.white
                    : Colors.black,
            label: Text(
              'Play Last Video',
            ),
            backgroundColor: themeDark,
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WebPageVideo(videoTitle, videoLink)),
                ));
  }
}
