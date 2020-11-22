import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:iteraio/pages/login_page.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/widgets/on_pop.dart';

class PreHome extends StatelessWidget {
  static const routeName = '/pre-home';

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: OnPop(context: context).onWillPop,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              buildSliverAppBar(context),
            ];
          },
          body: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage(
              //     'assets/logos/icon.png',
              //   ),
              //   scale: 0.5,
              // ),
              backgroundBlendMode: BlendMode.darken,
              gradient: LinearGradient(
                  begin: FractionalOffset.bottomRight,
                  end: FractionalOffset.topLeft,
                  colors: [
                    Colors.purpleAccent.withOpacity(0.0),
                    colorDark.withOpacity(0.9),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ]),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text: 'SOA/ITER\n',
                        style: TextStyle(fontSize: 18),
                        children: [
                          TextSpan(
                            text:
                                'Institute of Technical Education and Research',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '''\n
⭐ It was established in 1996. This is the Engineering School of Siksha 'O' Anusandhan (formerly SOA University or SIksha 'O' Anusandhan). 
⭐ Faculty of Engineering and Technology is placed at 32nd rank by NIRF and Govt of India. 
⭐ Times Higher Education(THE) World University ranking 2020 has ranked its Engineering and Technology, Computer Sciences & Health science in 601 + bracket. 
⭐ Besides all this, it has been placed within top 50 among Indian Universities.''',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (!firebaseSignedIn)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: FlatButton.icon(
                            color: Colors.blueAccent,
                            icon: Icon(LineAwesomeIcons.google_plus),
                            label: Text('Google Sign in'),
                            onPressed: () {},
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: FlatButton.icon(
                            color: colorDark.withOpacity(1),
                            icon: Icon(Icons.business),
                            label: Text('Campus Portal Login'),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                )),
                          ),
                        ),
                      ],
                    ),
                  if (isLoggedIn ?? false)
                    Container(
                      width: width * 0.95,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: FlatButton.icon(
                          color: Colors.blueAccent,
                          icon: Icon(LineAwesomeIcons.home),
                          label: Text('Go to Home'),
                          onPressed: () => Navigator.pushNamed(
                              context, MyHomePage.routeName),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Clubs',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Wrap(
                    children: [
                      for (var item in clubList)
                        clubCard(context, item['name'], item['logoUrl'],
                            item['desc'])
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final clubList = [
    {
      'name': 'CODEX',
      'desc': 'WE CODE WE EXPLORE!\nThe only coding club of ITER',
      'logoUrl': 'https://avatars0.githubusercontent.com/u/32349210?s=200&v=4',
      'resgisterLink': ''
    },
    {
      'name': 'SMC',
      'desc': 'Soa Music Club\nLets Sing Together! ',
      'logoUrl':
          'https://scontent-ort2-1.cdninstagram.com/v/t51.2885-19/43160709_353453038559402_7176192642768699392_n.jpg?_nc_ht=scontent-ort2-1.cdninstagram.com&_nc_ohc=vO09Qo66d4sAX8BB8jz&oh=7eefffa442fb63326c716f3737012bda&oe=5FE570A9',
      'resgisterLink': ''
    },
    {
      'name': 'Shristi',
      'desc': 'Srishti - Brushing The Beyond\nWe make things beautiful',
      'logoUrl':
          'https://scontent-ort2-2.cdninstagram.com/v/t51.2885-19/92824595_640241626535346_1252290142845009920_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com&_nc_ohc=HOo1XhVQg2AAX_8OO2q&oh=61fa13c8d9d37a973a0e274fd5676c05&oe=5FE2E8BE',
      'resgisterLink': ''
    },
    {
      'name': 'Odanza',
      'desc': 'Dance in traditional way!\nChalo dance kare or tod de ye floor.',
      'logoUrl': '',
      'resgisterLink': ''
    },
  ];

  Widget clubCard(
      BuildContext context, String clubName, String logoUrl, String desc) {
    var _width = MediaQuery.of(context).size.width * 0.45;
    return Container(
      width: _width,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorDark.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
              blurRadius: 10, color: Colors.black38, offset: Offset(1, 1)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: _width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    color: colorDark.withOpacity(0.2),
                    offset: Offset(0, 1)),
              ],
            ),
            child: Container(
              padding: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: _width * 0.9,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            alignment: Alignment.topLeft,
            child: Text(
              clubName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            alignment: Alignment.topLeft,
            child: Text(
              desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    // var _isExpanded = true;
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.35,
      forceElevated: true,
      // collapsedHeight: MediaQuery.of(context).size.height * 0.09,
      floating: false,
      centerTitle: true,
      pinned: false,
      elevation: 10,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.bottomLeft,
          child: RichText(
            softWrap: true,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: "Welcome to ITER",
              style: TextStyle(
                // fontFamily: fontName,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                shadows: <Shadow>[
                  Shadow(
                      offset: Offset(2.5, 2.5),
                      blurRadius: 8.0,
                      color: colorDark),
                ],
              ),
            ),
          ),
        ),
        background: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              alignment: Alignment.bottomCenter,
              child: Image.network(
                  'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.0TalO1gv_hFh3o52sW8p8gHaE7%26pid%3DApi&f=1',
                  fit: BoxFit.fitHeight),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.bottomRight,
                      end: FractionalOffset.topLeft,
                      colors: [
                        colorDark.withOpacity(0.0),
                        colorDark.withOpacity(0.9),
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
