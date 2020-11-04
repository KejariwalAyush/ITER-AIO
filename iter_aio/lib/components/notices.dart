import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/widgets/WebPageView.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Notices extends StatefulWidget {
  @override
  _NoticesState createState() => _NoticesState();
}

List iterNoticeData = List();
List iterExamNoticeData = List();
List soaNoticeData = List();
int currentIndex = 0;
bool showExamNotice = false;

class _NoticesState extends State<Notices> {
  var _isLoading = false;
  FetchNotice _fetchNotice;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _fetchNotice = new FetchNotice();
    if (iterExamNoticeData != null &&
        iterNoticeData != null &&
        soaNoticeData != null)
      setState(() {
        _isLoading = false;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notices & News'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: new Icon(Icons.feedback),
        //     onPressed: () {
        //       Wiredash.of(context).show();
        //     },
        //   ),
        // ],
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.business_center),
              // ignore: deprecated_member_use
              title: Text('ITER')),
          BottomNavigationBarItem(
              icon: Icon(Icons.business),
              // ignore: deprecated_member_use
              title: Text('SOA')),
        ],
        selectedItemColor: themeDark,
        elevation: 5,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            if (value == 0) {
              if (iterNoticeData == null) _fetchNotice.getIterNotices();
            } else {
              if (soaNoticeData == null) _fetchNotice.getSoaNotices();
            }
          });
        },
        selectedFontSize: 18,
        unselectedFontSize: 12,
        unselectedIconTheme: IconThemeData(size: 16),
      ),
      body: _isLoading
          ? Center(
              child: Container(
                  height: 200, child: loading()), //CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      currentIndex == 0
                          ? showExamNotice
                              ? 'ITER Exam Notices'
                              : 'ITER Notices'
                          : 'SOA News & Events',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  currentIndex == 0
                      ? Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Exam Notices'),
                              Switch.adaptive(
                                value: showExamNotice,
                                onChanged: (value) {
                                  setState(() {
                                    showExamNotice = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  if (iterNoticeData == null || soaNoticeData == null)
                    Center(child: Text('No Data Available!'))
                  else
                    for (var i in currentIndex == 0
                        ? showExamNotice
                            ? iterExamNoticeData
                            : iterNoticeData
                        : soaNoticeData)
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WebPageView(i['title'], i['link']))),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: colorDark,
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: colorDark,
                            //       blurRadius: 2,
                            //       spreadRadius: 2)
                            // ]
                          ),
                          margin: EdgeInsets.only(
                              top: 5, right: 10, left: 10, bottom: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: ListTile(
                            // contentPadding: EdgeInsets.all(10.0),
                            title: Text(
                              '${i['title']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                text: '\n${i['time']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: brightness == Brightness.light
                                        ? Colors.black54
                                        : Colors.white54),
                                // children: [
                                //   TextSpan(
                                //     text: '\nAuthor: ${i['author']}',
                                //     style: TextStyle(
                                //         color: MediaQuery.of(context)
                                //                     .platformBrightness ==
                                //                 Brightness.light
                                //             ? Colors.black38
                                //             : Colors.white38),
                                //   ),
                                // ]
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }
}

class FetchNotice {
  FetchNotice() {
    getIterNotices();
    getSoaNotices();
  }
  getIterNotices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _isLoading = true;
    // });
    final mainurl = 'https://www.soa.ac.in';
    var resp = await http.get(mainurl + '/iter-student-notice/');
    var resp2 = await http.get(mainurl + '/iter-exam-notice/');
    // print(mainurl + '/iter-student-notice/');
    if (resp.statusCode == 200) {
      var doc = parse(resp.body);
      var doc2 = parse(resp2.body);
      var links = doc.querySelectorAll('main > section > section > article');
      var links2 = doc2.querySelectorAll('main > section > section > article');
      // print(links.length);
      List<Map<String, dynamic>> linkMap = [];
      // print(linkMap);
      for (var link in links) {
        linkMap.add({
          'title': link.querySelector('a').text,
          'link': mainurl + link.querySelector('a').attributes['href'],
          'author': link.querySelector('div > a').text,
          'time': link.querySelector('div > time').text,
        });
      }
      iterNoticeData = linkMap;
      List<Map<String, dynamic>> linkMap2 = [];
      // print(linkMap);
      for (var link in links2) {
        linkMap2.add({
          'title': link.querySelector('a').text,
          'link': mainurl + link.querySelector('a').attributes['href'],
          'author': link.querySelector('div > a').text,
          'time': link.querySelector('div > time').text,
        });
      }
      iterExamNoticeData = linkMap2;
      // print(linkMap[0]);
    } else {
      iterNoticeData = null;
    }

    // setState(() {
    //   _isLoading = false;
    // });
    await prefs.setString('examNotice', iterExamNoticeData[0].toString());
    await prefs.setString('iterNotice', iterNoticeData[0].toString());
  }

  getSoaNotices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _isLoading = true;
    // });
    final mainurl = 'https://www.soa.ac.in';
    var resp = await http.get(mainurl + '/general-notifications/');
    // print(mainurl + '/iter-student-notice/');
    if (resp.statusCode == 200) {
      var doc = parse(resp.body);
      var links = doc.querySelectorAll('main > section > section > article');
      // print(links.length);
      List<Map<String, dynamic>> linkMap = [];
      // print(linkMap);
      for (var link in links) {
        linkMap.add({
          'title': link.querySelector('a').text,
          'link': mainurl + link.querySelector('a').attributes['href'],
          'author': link.querySelector('div > a').text,
          'time': link.querySelector('div > time').text,
        });
      }
      soaNoticeData = linkMap;
      // print(linkMap[0]);
    } else {
      soaNoticeData = null;
    }
    // setState(() {
    //   _isLoading = false;
    // });
    await prefs.setString('soaNotice', soaNoticeData[0].toString());
  }
}
