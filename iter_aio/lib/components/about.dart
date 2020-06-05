import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';

class AboutUs extends StatelessWidget {
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
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Image.asset(
                  'assets/logos/codex.jpg',
                  fit: BoxFit.contain,
                )),
                Expanded(
                    child: Image.asset(
                  'assets/logos/icon.png',
                  fit: BoxFit.contain,
                )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'THIS APP DOES NOT PROMOTE BUNKING. THE APP WAS DESIGNED TO ENSURE THAT YOU CAN MANAGE A PROPER ATTENDANCE AND BUNK SAFELY.THE ATTENDANCE & DATA SHOWN IS COMPLETELY MANAGED BY COLLEGE.THE DEVELOPER IS NOT RESPONSIBLE FOR INACCURATE ATTENDANCE & DATA OR DELAY IN ATTENDANCE UPDATE.',
                textAlign: TextAlign.center,
              ),
            ),
            // Row(children: <Widget>[
            //   // Icon(Icons.)
            // ],)
          ],
        ),
      )),
    );
  }
}
