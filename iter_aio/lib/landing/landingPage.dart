import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:iteraio/pages/login_page.dart';
import 'package:iteraio/MyHomePage.dart';
import 'package:iteraio/widgets/on_pop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iteraio/pages/clubs/club_details.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:iteraio/landing/signInForm.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
User user;
var gUser;

class LandingPage extends StatefulWidget {
  static const routeName = '/landing-page';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: OnPop(context: context).onWillPop,
      child: Scaffold(
        appBar: AppBar(
          bottomOpacity: 0.2,
          // elevation: 20,
          leadingWidth: 45,
          automaticallyImplyLeading: false,
          // leading: Container(
          //     padding: EdgeInsets.all(5),
          //     child: CircleAvatar(child: Image.asset('assets/logos/icon.png'))),
          title: Text('ITER-AIO'),
          centerTitle: user == null ?? true,
          actions: [
            if (user != null ?? false)
              FlatButton.icon(
                color: Colors.blueAccent,
                icon: Icon(LineAwesomeIcons.power_off),
                label: Text('Logout'),
                onPressed: () {
                  setState(() {
                    signOutGoogle().then((value) => user = null);
                    user = null;
                  });
                },
              ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
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
                buildHeaderImage(context),
                SizedBox(
                  height: 10,
                ),
                buildHeaderText(),
                SizedBox(
                  height: 15,
                ),
                if (user == null || !firebaseSignedIn ?? true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: FlatButton.icon(
                          color: Colors.blueAccent,
                          icon: Icon(LineAwesomeIcons.google_plus),
                          label: Text('Google Sign in'),
                          onPressed: () {
                            signInWithGoogle().then((result) {
                              if (result != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SignInForm(
                                        user: user,
                                      );
                                    },
                                  ),
                                );
                              }
                            });
                          },
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
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: FlatButton.icon(
                      color: Colors.blueAccent,
                      icon: Icon(LineAwesomeIcons.home),
                      label: Text('Go to Home'),
                      onPressed: () =>
                          Navigator.pushNamed(context, MyHomePage.routeName),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Clubs',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
                  ),
                ),
                FutureBuilder(
                  future: clubs.get().then((QuerySnapshot querySnapshot) {
                    List _list = [];
                    querySnapshot.docs.forEach((doc) {
                      _list.add(doc);
                    });
                    return _list;
                  }),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        height: 200,
                        child: loading(),
                      );
                    else
                      return Wrap(
                        children: [
                          for (QueryDocumentSnapshot item in snapshot.data)
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClubDetails(doc: item),
                                  )),
                              child: clubCard(context, item['name'],
                                  item['logoUrl'], item['desc']),
                            )
                        ],
                      );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RichText buildHeaderText() {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
          text: 'SOA/ITER\n',
          style: TextStyle(fontSize: 18),
          children: [
            TextSpan(
              text: 'Institute of Technical Education and Research',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '''\n
⭐ It was established in 1996. This is the Engineering School of Siksha 'O' Anusandhan (formerly SOA University or SIksha 'O' Anusandhan). 
⭐ Faculty of Engineering and Technology is placed at 32nd rank by NIRF and Govt of India. 
⭐ Times Higher Education(THE) World University ranking 2020 has ranked its Engineering and Technology, Computer Sciences & Health science in 601 + bracket. 
⭐ Besides all this, it has been placed within top 50 among Indian Universities.''',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ]),
    );
  }

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

  Widget buildHeaderImage(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40))),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.33,
            alignment: Alignment.bottomCenter,
            child: Image.network(
                'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.0TalO1gv_hFh3o52sW8p8gHaE7%26pid%3DApi&f=1',
                fit: BoxFit.cover),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.33,
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
          Container(
            height: MediaQuery.of(context).size.height * 0.33,
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            child: RichText(
              softWrap: true,
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              text: TextSpan(
                text: "Welcome to ITER",
                style: TextStyle(
                  // fontFamily: fontName,
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
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
        ],
      ),
    );
  }
}
