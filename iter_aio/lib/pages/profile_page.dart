import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/models/login_model.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/widgets/large_appdrawer.dart';
import 'package:iteraio/widgets/loading.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          // bottomRight: Radius.circular(25)
        )),
      ),
      body: Row(
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
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(5),
                      child: buildHeader(context),
                    ),
                    FutureBuilder<ProfileInfo>(
                      future: pi.getProfile(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Container(
                            height: 200,
                            child: loading(),
                          );
                        else
                          return Column(
                            children: [
                              buildRichText(context, 'Semester',
                                  snapshot.data.semester.toString()),
                              buildRichText(
                                  context, 'Regd No.', snapshot.data.regdno),
                              buildRichText(
                                  context, 'Branch', snapshot.data.branchdesc),
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
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white,
            ),
          ),
          Text(
            _desc,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
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

  String flareAni = 'hello';
  Widget buildHeader(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              if (flareAni == 'fly')
                flareAni = 'hello';
              else
                flareAni = 'fly';
            });
          },
          child: Container(
            height: 180,
            // width: 100,
            child: FlareActor("assets/animations/ITER-AIO.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: flareAni),
          ),
        ),
        InkWell(
          // onTap: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => ResultPage(),
          //     )),
          child: FutureBuilder<ProfileInfo>(
            future: pi.getProfile(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return FutureBuilder<LoginData>(
                    future: loginFetch.getLogin(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: Text('Waiting for Info!'),
                        );
                      else
                        return Center(child: Text(snapshot.data.status));
                    });
              else
                // if(loginFetch.finalLogin.status == 'Error Logging In')
                return RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    text: snapshot.data.name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black87
                          : Colors.white,
                    ),
                  ),
                );
            },
          ),
        )
      ],
    );
  }
}
