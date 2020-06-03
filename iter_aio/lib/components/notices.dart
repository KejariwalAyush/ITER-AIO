import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:iteraio/Themes/Theme.dart';
import 'package:iteraio/widgets/WebPageView.dart';
import 'package:wiredash/wiredash.dart';
import 'package:http/http.dart' as http;

class Notices extends StatefulWidget {
  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  List iterNoticeData = List();
  List iterExamNoticeData = List();
  List soaNoticeData = List();
  var _isLoading = false;
  int currentIndex = 0;
  bool showExamNotice = false;
  @override
  void initState() {
    getIterNotices();
    getSoaNotices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notices & News'),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.feedback),
            onPressed: () {
              Wiredash.of(context).show();
            },
          ),
        ],
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.business_center), title: Text('ITER')),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('SOA')),
        ],
        selectedItemColor: themeDark,
        elevation: 5,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            if (value == 0) {
              if (iterNoticeData == null) getIterNotices();
            } else {
              if (soaNoticeData == null) getSoaNotices();
            }
          });
        },
        selectedFontSize: 16,
        unselectedFontSize: 14,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
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
                          : 'SOA Notices',
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
                        ? showExamNotice ? iterExamNoticeData : iterNoticeData
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
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.light
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

  getIterNotices() async {
    setState(() {
      _isLoading = true;
    });
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
    setState(() {
      _isLoading = false;
    });
  }

  getSoaNotices() async {
    setState(() {
      _isLoading = true;
    });
    final mainurl = 'https://www.soa.ac.in';
    var resp = await http.get(mainurl + '/general-notifications/');
    print(mainurl + '/iter-student-notice/');
    if (resp.statusCode == 200) {
      var doc = parse(resp.body);
      var links = doc.querySelectorAll('main > section > section > article');
      print(links.length);
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
      print(linkMap[0]);
    } else {
      soaNoticeData = null;
    }
    setState(() {
      _isLoading = false;
    });
  }
}
