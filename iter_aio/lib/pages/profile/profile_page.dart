import 'dart:math';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/widgets/large_appdrawer.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:iteraio/models/firestore_to_model.dart';
import 'package:iteraio/pages/profile/profile_form.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String flareAni;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _height = 180, _width = 200;
  var _alignment = Alignment.center;

  @override
  void initState() {
    flareAni = 'hello';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomAppDrawer(
              sresult: true,
              slectures: true,
              sbunk: true,
              slogout: true,
              srestart: true)
          .widgetDrawer(context),
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        leading: MediaQuery.of(context).size.width > 700
            ? SizedBox()
            : Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.apps),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileForm(),
                )),
          )
        ],
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(35),
                // bottomRight: Radius.circular(25)
                )),
      ),
      body: Container(
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
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildStackHeader(),
                      FutureBuilder<ProfileInfo>(
                        // future: pi.getProfile(),
                        future: users.doc(regdNo).get().then((value) =>
                            FirestoretoModel().profileInfo(value['profile'])),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Container(
                              height: 200,
                              child: loading(),
                            );
                          else
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: snapshot.data.name,
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black87
                                              : Colors.white,
                                        ),
                                        children: [
                                          if (emailId != null || emailId != '')
                                            TextSpan(
                                              text: '\n$emailId',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colors.black87
                                                    : Colors.white,
                                              ),
                                            )
                                        ]),
                                  ),
                                ),
                                buildRichText(context, 'Semester',
                                    snapshot.data.semester.toString()),
                                buildRichText(
                                    context, 'Regd No.', snapshot.data.regdno),
                                buildRichText(context, 'Branch',
                                    snapshot.data.branchdesc),
                                buildRichText(context, 'Section',
                                    snapshot.data.sectioncode),
                                buildRichText(
                                    context, 'Gender', snapshot.data.gender),
                                buildRichText(
                                    context, 'Email', snapshot.data.email),
                                buildRichText(context, 'R. Pincode',
                                    snapshot.data.pincode.toString()),
                              ],
                            );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack buildStackHeader() {
    return Stack(
      children: [
        if (imgUrl != null || imgUrl != '')
          Container(
            alignment: Alignment.bottomLeft,
            height: 250,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            child: CircleAvatar(
              maxRadius: 65,
              minRadius: 20,
              backgroundColor: colorDark,
              backgroundImage: NetworkImage(imgUrl),
              onBackgroundImageError: (exception, stackTrace) {
                SnackBar snackBar = SnackBar(
                  content: Text('Error loading Profile Image'),
                );
                // ignore: deprecated_member_use
                _scaffoldKey.currentState.showSnackBar(snackBar);
              },
            ),
          ),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(5),
          alignment: (imgUrl != null || imgUrl != '')
              ? Alignment.centerRight
              : Alignment.center,
          child: AnimatedContainer(
            duration: Duration(seconds: 2),
            alignment: _alignment,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (flareAni == 'fly' || flareAni == 'closeEyes') {
                    flareAni = 'openEyes';
                    Future.delayed(Duration(seconds: 1)).whenComplete(() {
                      setState(() {
                        flareAni = 'fly';
                        _width = 220;
                        _height = 220;
                        _alignment = Alignment.center;
                        Future.delayed(Duration(seconds: 1)).whenComplete(() {
                          setState(() {
                            flareAni = 'hello';
                          });
                        });
                      });
                    });
                  } else {
                    // random generator
                    final random = Random();
                    _width = random.nextInt(150).toDouble() + 50;
                    _height = random.nextInt(150).toDouble() + 60;
                    _alignment = random.nextInt(10) % 2 == 0
                        ? Alignment.centerRight
                        : Alignment.bottomRight;
                    flareAni = 'fly';
                    Future.delayed(Duration(seconds: 2)).whenComplete(() {
                      setState(() {
                        flareAni = 'closeEyes';
                      });
                    });
                  }
                });
              },
              child: AnimatedContainer(
                width: _width,
                height: _height,
                alignment: _alignment,
                duration: Duration(seconds: 2),
                curve: Curves.fastOutSlowIn,
                // width: 100,
                child: FlareActor("assets/animations/ITER-AIO.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: flareAni),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRichText(BuildContext context, String _name, String _desc) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
      child: Wrap(
        direction: Axis.horizontal, runSpacing: 8, spacing: 30,
        runAlignment: WrapAlignment.start,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _name + ' : ',
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white,
            ),
          ),
          Text(
            _desc,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
