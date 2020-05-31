import 'package:flutter/material.dart';
import 'package:iteraio/components/lectures.dart';
import 'package:iteraio/Themes/Theme.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:wiredash/wiredash.dart';

class Courses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        elevation: 15,
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.feedback),
            onPressed: () {
              Wiredash.of(context).show();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: isLoading || courseData == null
          ? Center(
              child: CircularProgressIndicator(),
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
                              contentPadding: EdgeInsets.only(top: 5, left: 30),
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
