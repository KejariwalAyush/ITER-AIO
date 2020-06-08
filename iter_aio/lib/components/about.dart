import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';
import 'package:iteraio/widgets/WebPageView.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
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
              height: 20,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'THIS APP DOES NOT PROMOTE BUNKING.\n\nTHE APP WAS DESIGNED TO ENSURE THAT YOU CAN MANAGE A PROPER ATTENDANCE AND BUNK SAFELY.THE ATTENDANCE & DATA SHOWN IS COMPLETELY MANAGED BY COLLEGE.\n\nTHE DEVELOPER IS NOT RESPONSIBLE FOR INACCURATE ATTENDANCE & DATA OR DELAY IN ATTENDANCE UPDATE.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebPageView('Facebook',
                            'https://www.facebook.com/ayushkejariwal.ayush'),
                      )),
                  icon: Icon(
                    LineAwesomeIcons.facebook,
                    size: 45,
                    color: Colors.blueAccent,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebPageView('Instagram',
                            'https://www.instagram.com/a_kejariwal/'),
                      )),
                  icon: Icon(
                    LineAwesomeIcons.instagram,
                    size: 45,
                    color: Colors.orangeAccent,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebPageView('LinkedIn',
                            'https://www.linkedin.com/in/ayush-kejariwal-1923a2191/'),
                      )),
                  icon: Icon(
                    LineAwesomeIcons.linkedin_square,
                    size: 45,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebPageView(
                            'Github', 'https://www.github.com/KejariwalAyush'),
                      )),
                  icon: Icon(
                    LineAwesomeIcons.github_square,
                    size: 45,
                    color: Colors.white60,
                  ),
                ),
                IconButton(
                  onPressed: () => _launchURL('mailto:iteraio2020@gmail.com'),
                  icon: Icon(
                    LineAwesomeIcons.inbox,
                    size: 45,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 15,
            // ),
            // Center(
            //   child: SelectableText('Email Us at: iteraio2020@gmail.com'),
            // ),
            SizedBox(
              height: 15,
            ),
            Divider(
              height: 15,
              thickness: 5,
            ),
            InkWell(
              onTap: () => Wiredash.of(context).show(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      LineAwesomeIcons.bug,
                      size: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Report a Bug/Request a feature',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  _launchURL(String url) async {
    // const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return;
  }
}
