import 'package:flutter/material.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iteraio/Utilities/global_var.dart';

class ClubsPage extends StatefulWidget {
  ClubsPage({Key key}) : super(key: key);

  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
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
          bottomLeft: Radius.circular(35),
          // bottomRight: Radius.circular(25)
        )),
      ),
      body: Container(
        child: FutureBuilder<List<String>>(
            future: clubs.get().then((QuerySnapshot querySnapshot) {
              List<String> _list = [];
              querySnapshot.docs.forEach((doc) {
                _list.add(doc['name']);
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
                      for (var item in snapshot.data)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: ListTile(
                            leading: Icon(Icons.graphic_eq),
                            title: Text(item),
                          ),
                        ),
                    ],
                  ),
                );
            }),
      ),
    );
  }
}
