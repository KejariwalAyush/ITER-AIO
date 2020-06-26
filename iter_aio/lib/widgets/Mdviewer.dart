import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;

// ignore: must_be_immutable
class MdViewer extends StatelessWidget {
  String title, data;
  MdViewer(this.title, this.data);

  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    // var _markdownData = getFileData(fileName);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: FutureBuilder(
          future: rootBundle.loadString("assets/policy/PrivacyPolicy.md"),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Markdown(data: snapshot.data);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.arrow_upward),
      //   onPressed: () => controller.animateTo(0,
      //       duration: Duration(seconds: 1), curve: Curves.easeOut),
      // ),
    );
  }
}
