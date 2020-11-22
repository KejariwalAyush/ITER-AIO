import 'package:flutter/material.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:iteraio/Utilities/theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/pages/clubs/club_details.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iteraio/widgets/on_pop.dart';

class ClubsPage extends StatefulWidget {
  static const routeName = "/clubs-page";
  ClubsPage({Key key}) : super(key: key);

  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  // @override
  // void initState() {
  //   clubs.doc('codechef').set(codechefFeilds);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: OnPop(context: context).onWillPop,
      child: Scaffold(
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
          actions: [
            if (admin)
              IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () => showDialog(
                  context: context,
                  // barrierDismissible: false,
                  builder: (BuildContext context) => _buildAboutDialog(context),
                ),
              )
          ],
        ),
        // bottomSheet: Container(
        //     height: 20,
        //     alignment: Alignment.center,
        //     child: Text('For adding Clubs or any query head over to About Us')),
        body: Container(
          // color: colorDark.withOpacity(0.1),
          height: double.maxFinite,
          child: buildFutureBuilder(),
        ),
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
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.group,
                                    size: 30,
                                  ),
                                ),
                          title: Text(
                            item['name'],
                            overflow: TextOverflow.ellipsis,
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

  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Add new Club'),
      content: FormBuilder(
        key: _fbKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new FormBuilderTextField(
              attribute: "key",
              decoration: InputDecoration(labelText: "Key Name (No Spaces)"),
              validators: [FormBuilderValidators.required()],
            ),
            new FormBuilderTextField(
              attribute: "clubName",
              decoration: InputDecoration(labelText: "Club Name"),
              validators: [FormBuilderValidators.required()],
            ),
            new FormBuilderTextField(
              attribute: "imgUrl",
              decoration: InputDecoration(labelText: "Logo Url"),
              // validators: [FormBuilderValidators.required()],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('Cancel'),
        ),
        new FlatButton(
          onPressed: () {
            if (_fbKey.currentState.saveAndValidate()) {
              var x = _fbKey.currentState.value;
              print(x);
              clubs
                  .doc(x['key'].toString().toLowerCase())
                  .set(addNewClubFeilds(x['clubName'], imgUrl: x['imgUrl']));

              Navigator.of(context).pop();
            }
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('Done'),
        ),
      ],
    );
  }

  // var codechefFeilds = {
  //   'name': 'CodeChef ITER chapter',
  //   'desc':
  //       '''This is the Codechef Chapter of ITER. This club is a community of Competitive Programming(CP) who can help you with your DSA, Algo, etc.''',
  //   'logoUrl':
  //       'https://media-exp1.licdn.com/dms/image/C4E03AQEGTPInAWIepg/profile-displayphoto-shrink_800_800/0?e=1611187200&v=beta&t=PCA6tuIO1J0DqrD8UEWG2Fg6Z6MQJRUhDYIwxCINbcE',
  //   'instaLink': 'https://www.instagram.com/iter_codechef/',
  //   'otherLinks':
  //       'https://www.linkedin.com/in/codechef-iter-chapter-9492771bb/',
  //   'howToJoin':
  //       'If you are Intrested in CP then contact us through the mentioned links.',
  //   'benifits': 'Will improve your skills and hold on DSA, Algo, etc for CP',
  //   'activity': 'HackerWar 2.0, Hackodex & some Webinars',
  //   'coordinators': ['1941012408'],
  //   'members': [],
  //   'anouncemnts': []
  // };
  addNewClubFeilds(String name, {String imgUrl}) {
    return {
      'name': name,
      'desc': '',
      'logoUrl': imgUrl ?? '',
      'instaLink': '',
      'otherLinks': '',
      'howToJoin': '',
      'benifits': '',
      'activity': '',
      'coordinators': ['$regdNo'],
      'members': [],
      'anouncemnts': []
    };
  }
}
