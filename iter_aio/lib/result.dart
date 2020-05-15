import 'package:flutter/material.dart';

import 'MyHomePage.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITER AIO'),
        elevation: 15,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.share,
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: isLoading || resultData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                ),
//                                child: Image.asset('male.webp',fit: BoxFit.cover,),
                                radius: 40,
//                                backgroundColor: Colors.purple[100],
                              )),
                          Expanded(
                            flex: 3,
                            child: RichText(
                              textAlign: TextAlign.end,
                              text: TextSpan(
                                  text: '$name',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  children: [
                                    TextSpan(
                                        text: '\nRegd. No.:$regdNo',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54)),
                                    TextSpan(
                                        text: '\nSemester: $sem',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54)),
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
//                  for (int i=0;i<resultData.length;i++)
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            title: Text(
                              'Comming Soon!!',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            children: <Widget>[],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
