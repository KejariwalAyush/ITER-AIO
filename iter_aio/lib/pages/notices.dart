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
  int originalSize = 800;
  @override
  Widget build(BuildContext context) {
    Widget examSwitch = currentIndex == 0
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
        : SizedBox();
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
          });
        },
        selectedFontSize: 18,
        unselectedFontSize: 12,
        unselectedIconTheme: IconThemeData(size: 16),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width > 700)
            LargeAppDrawer().largeDrawer(context),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: examSwitch,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      currentIndex == 0
                          ? showExamNotice
                              ? 'ITER Exam Notices'
                              : 'ITER Notices'
                          : 'SOA News & Events',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<List<NoticeContent>>(
                    // future: nf.getIterNotices(),
                    future: currentIndex == 0
                        ? showExamNotice
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
        ],
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
}
