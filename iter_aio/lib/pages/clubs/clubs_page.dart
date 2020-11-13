import 'package:flutter/material.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:iteraio/Utilities/theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/pages/clubs/club_details.dart';

class ClubsPage extends StatefulWidget {
  ClubsPage({Key key}) : super(key: key);

  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  // @override
  // void initState() {
  //   clubs.doc('codex').set(codexFeilds);
  //   clubs.doc('srishti').set(srishtiFeilds);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomAppDrawer(
              sresult: true,
              slectures: true,
              sbunk: true,
              slogout: true,
              srestart: true)
          .widgetDrawer(context),
      appBar: AppBar(
        title: Text('Clubs'),
        centerTitle: true,
        elevation: 15,
        leading: MediaQuery.of(context).size.width > 700
            ? SizedBox()
            : Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.apps),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(35),
                // bottomRight: Radius.circular(25)
                )),
      ),
      body: Container(
        // color: colorDark.withOpacity(0.1),
        height: double.maxFinite,
        child: buildFutureBuilder(),
      ),
    );
  }

  FutureBuilder<List> buildFutureBuilder() {
    return FutureBuilder<List>(
        future: clubs.get().then((QuerySnapshot querySnapshot) {
          List _list = [];
          querySnapshot.docs.forEach((doc) {
            _list.add(doc);
          });
          return _list;
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
              height: 200,
              child: loading(),
            );
          else
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (QueryDocumentSnapshot item in snapshot.data)
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClubDetails(doc: item),
                            )),
                        child: ListTile(
                          trailing: item['logoUrl'] != ''
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(item['logoUrl']),
                                  maxRadius: 30,
                                )
                              : Icon(
                                  Icons.group,
                                  size: 30,
                                ),
                          title: Text(
                            item['name'],
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
        });
  }

  // var codexFeilds = {
  //   'name': 'CODEX',
  //   'desc': '''The Only Coding Club of ITER.
  // We code,we explore. This club is a community of coders who can help you with your programming stuff and any other Programming related doubts.''',
  //   'logoUrl': 'https://avatars0.githubusercontent.com/u/32349210?s=200&v=4',
  //   'instaLink': 'https://www.instagram.com/codexiter/',
  //   'otherLinks': 'https://github.com/codex-iter http://t.me/codexinit',
  //   'howToJoin':
  //       'Follow the Above init link to Join the club. You need to solve some problems to enter the club.',
  //   'benifits':
  //       'Build a Community with us and get help from seniors for your problems.',
  //   'activity': 'HackerWar 2.0, Hackodex & some Webinars',
  //   'coordinators': ['1941012408', '1941012661'],
  //   'members': [],
  //   'anouncemnts': []
  // };
  // var srishtiFeilds = {
  //   'name': 'Srishti',
  //   'desc':
  //       '''Art Club. Brushing The Beyond. We do all kinds of Painting, Art, Digital Posters, Artifects, etc.''',
  //   'logoUrl':
  //       'https://scontent-ort2-2.cdninstagram.com/v/t51.2885-19/92824595_640241626535346_1252290142845009920_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com&_nc_ohc=Fylx7huogUAAX_t0nMY&oh=cf0cc3e31469c05851c53b48a9a229c8&oe=5FD70B3E',
  //   'instaLink': 'https://www.instagram.com/srishticlub/',
  //   'otherLinks': '',
  //   'howToJoin':
  //       'Joining us is a peice of cake if you love drawing, art, digital art. Just join us and we will explore.',
  //   'benifits': 'Build a Community with us to make world beautiful with paints',
  //   'activity': '',
  //   'coordinators': [],
  //   'members': [],
  //   'anouncemnts': []
  // };
}
