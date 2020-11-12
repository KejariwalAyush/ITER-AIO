import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/models/notices_model.dart';
import 'package:iteraio/widgets/WebPageView.dart';
import 'package:iteraio/widgets/large_appdrawer.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class Notices extends StatefulWidget {
  static const routeName = "/notices-page";
  @override
  _NoticesState createState() => _NoticesState();
}

int currentIndex = 0;
bool showExamNotice = false;

class _NoticesState extends State<Notices> {
  int originalSize = 1080;
  GlobalKey noticeKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notices & News'),
        centerTitle: true,
        leading: MediaQuery.of(context).size.width > 700
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        actions: <Widget>[
          if (isMobile)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                icon: new Icon(
                  Icons.share,
                ),
                onPressed: () {
                  if (isMobile)
                    ShareFilesAndScreenshotWidgets().shareScreenshot(
                        noticeKey,
                        originalSize,
                        "MyAttendance",
                        "Attendance.png",
                        "image/png",
                        text:
                            "Download ITER-AIO from here http://tiny.cc/iteraio");
                },
              ),
            ),
        ],
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(35),
                // bottomRight: Radius.circular(25)
                )),
      ),
      bottomNavigationBar: (MediaQuery.of(context).size.width > 700)
          ? SizedBox.shrink()
          : BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.school),
                    // ignore: deprecated_member_use
                    title: Text('ITER')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.backpack),
                    // ignore: deprecated_member_use
                    title: Text('Exam')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.business),
                    // ignore: deprecated_member_use
                    title: Text('SOA')),
              ],
              selectedItemColor: Colors.orangeAccent,
              elevation: 5,
              currentIndex: currentIndex,
              onTap: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              selectedFontSize: 18,
              unselectedFontSize: 12,
              unselectedIconTheme: IconThemeData(size: 16),
            ),
      body: RepaintBoundary(
        key: noticeKey,
        child: Container(
          color: colorDark.withOpacity(0.15),
          height: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (MediaQuery.of(context).size.width > 700)
                LargeAppDrawer().largeDrawer(context),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // Padding(
                            //   padding: const EdgeInsets.all(5.0),
                            //   child: examSwitch,
                            // ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                currentIndex == 0 || currentIndex == 1
                                    ? currentIndex == 1
                                        ? 'ITER Exam Notices'
                                        : 'ITER Notices'
                                    : 'SOA News & Events',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            ),
                            FutureBuilder<List<NoticeContent>>(
                              // future: nf.getIterNotices(),
                              future: currentIndex == 0 || currentIndex == 1
                                  ? currentIndex == 1
                                      ? nf.getIterExamNotices()
                                      : nf.getIterNotices()
                                  : nf.getSoaNotices(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 200,
                                    child: loading(),
                                  );
                                else
                                  return Column(
                                    children: [
                                      for (var item in snapshot.data)
                                        buildNoticeTile(item, context),
                                    ],
                                  );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (MediaQuery.of(context).size.width > 700)
                      Expanded(
                        flex: 1,
                        child: verticalNavigationBar(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildNoticeTile(NoticeContent nc, BuildContext context) {
    GlobalKey key = new GlobalKey(debugLabel: nc.title);
    return InkWell(
      onTap: !isMobile
          ? () => _launchURL(nc.link)
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebPageView(nc.title, nc.link))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: colorDark,
        ),
        margin: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Slidable(
          secondaryActions: [
            if (isMobile)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: colorDark,
                ),
                child: IconSlideAction(
                  caption: 'Share',
                  color: Colors.transparent,
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  closeOnTap: true,
                  onTap: () {
                    ShareFilesAndScreenshotWidgets().shareScreenshot(
                        key, originalSize, "Notice", "Notice.png", "image/png",
                        text:
                            "Visit: ${nc.link}\n\nDownload ITER-AIO from here http://tiny.cc/iteraio");
                  },
                ),
              ),
          ],
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.20,
          child: RepaintBoundary(
            key: key,
            child: ListTile(
              title: Text(
                '${nc.title}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: RichText(
                text: TextSpan(
                  text: '\n${nc.time}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white54),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
      ),
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

  Widget verticalNavigationBar() {
    return NavigationRail(
      minWidth: 55.0,
      groupAlignment: 0.0,
      backgroundColor: colorDark,
      selectedIndex: currentIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: <Widget>[],
      ),
      selectedLabelTextStyle: TextStyle(
        color: Colors.orangeAccent,
        fontSize: 14,
        letterSpacing: 1,
        decorationThickness: 2.0,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: 12,
        letterSpacing: 0.8,
      ),
      selectedIconTheme: IconThemeData(color: Colors.orange),
      // unselectedIconTheme: IconThemeData(color: Colors.orange),
      destinations: [
        textDestination("General", Icon(Icons.school)),
        textDestination("Exam", Icon(Icons.backpack)),
        textDestination("SOA", Icon(Icons.business)),
      ],
    );
  }

  NavigationRailDestination textDestination(String text, Icon icon) {
    return NavigationRailDestination(
      icon: icon,
      label: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: RotatedBox(
          quarterTurns: MediaQuery.of(context).size.height > 500 ? -1 : 0,
          child: Text(text),
        ),
      ),
    );
  }
}
