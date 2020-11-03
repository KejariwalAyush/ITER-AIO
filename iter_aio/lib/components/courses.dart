// import 'package:flutter/material.dart';
// import 'package:iteraio/components/Icons.dart';
// import 'package:iteraio/components/lectures.dart';
// import 'package:iteraio/Utilities/Theme.dart';
// import 'package:iteraio/MyHomePage.dart';
// import 'package:iteraio/components/videoPlayer.dart';
// import 'package:iteraio/main.dart';
// import 'package:iteraio/widgets/loading.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Courses extends StatefulWidget {
//   @override
//   _CoursesState createState() => _CoursesState();
// }

// class _CoursesState extends State<Courses> {
//   String videoTitle;
//   String videoLink;

//   void initState() {
//     setState(() {
//       _getLastVideoDetails();
//     });
//     super.initState();
//   }

//   _getLastVideoDetails() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       videoTitle = prefs.getString('video title');
//       videoLink = prefs.getString('video link');
//     });
//   }

//   bool showLectures = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ITER AIO'),
//         centerTitle: true,
//         elevation: 15,
//         // actions: <Widget>[
//         //   IconButton(
//         //     icon: new Icon(Icons.refresh),
//         //     onPressed: () {
//         //       lf = new LecturesFetch(semNo: 2);
//         //     },
//         //   ),
//         // ],
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(25),
//                 bottomRight: Radius.circular(25))),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: videoTitle == null
//           ? SizedBox()
//           : FloatingActionButton.extended(
//               // tooltip: 'Play Last Video',
//               icon: Icon(
//                 LineAwesomeIcons.play,
//               ),
//               foregroundColor:
//                   brightness == Brightness.dark || themeDark == themeDark1
//                       ? Colors.white
//                       : Colors.black,
//               label: Text(
//                 'Play Last Video',
//               ),
//               backgroundColor: themeDark,
//               onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             WebPageVideo(videoTitle, videoLink)),
//                   )),
//       body: isLoading || courseData == null
//           ? Center(
//               child: Container(height: 200, child: loading()),
//             )
//           : SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: 10,
//                   ),
//                   if (!showLectures)
//                     Center(
//                       child: Text(
//                         'Semester: $sem',
//                         style: TextStyle(fontSize: 15),
//                       ),
//                     )
//                   else
//                     Center(
//                       child: Text(
//                         'You are Viewing Lectures of Semester: ${sem - 1 == 0 ? 8 : (sem - 1)}',
//                         style: TextStyle(fontSize: 15),
//                       ),
//                     ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   if (!showLectures &&
//                       (sem == 1 || sem == 3 || sem == 5 || sem == 7))
//                     Center(
//                       child: RaisedButton(
//                         onPressed: () {
//                           setState(() {
//                             showLectures = true;
//                           });
//                         },
//                         elevation: 20,
//                         padding: EdgeInsets.all(20),
//                         child: Text(
//                           'New Lectures are yet to be Uploaded.\nWant to access old lectures!\nTap Here',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 15),
//                         ),
//                       ),
//                     )
//                   else
//                     for (var i in courseData)
//                       Container(
//                         padding: EdgeInsets.all(5),
//                         margin: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color:
//                               Theme.of(context).brightness == Brightness.light
//                                   ? colorLight
//                                   : colorDark,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: ExpansionTile(
//                           initiallyExpanded: false,
//                           title: Text(
//                             i['course'],
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                           children: <Widget>[
//                             for (var j in i['subjects'])
//                               ListTile(
//                                 contentPadding: EdgeInsets.only(
//                                     top: 5, left: 30, right: 15),
//                                 title: Text(
//                                   j['subject'],
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 subtitle: Text(
//                                   j['subjectCode'],
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 trailing: Image.asset(
//                                   subjectAvatar(j['subjectCode']),
//                                   width: 40,
//                                 ),
//                                 onTap: () => Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             Lectures(j['subject'], j['link']))),
//                               ),
//                           ],
//                         ),
//                       ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
