import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/pages/events_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var query = [];
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
        title: Text('Events'),
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
          if (admin)
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventsForm(),
                  )),
            ),
        ],
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          // bottomRight: Radius.circular(25)
        )),
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('events').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Container(height: 200, child: loading());
              else
                return ListView(
                    children: snapshot.data.docs.map((doc) {
                  return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, value, child) => Transform.scale(
                            scale: value,
                            child: buildEventTile(
                                doc['imgUrl'],
                                doc['title'],
                                doc['shortDesc'],
                                doc['clubName'],
                                new DateFormat.MMMd()
                                    .format(doc['eventDate'].toDate())),
                          ));
                }).toList());
            }),
      ),
    );
  }

  Widget buildEventTile(String imgUrl, String title, String shortDesc,
      String clubName, String eventDate) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: new BoxDecoration(
              color: colorDark.withOpacity(0.7),
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: MediaQuery.of(context).size.width < 700
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildImage(imgUrl),
                      buildRichText(eventDate, title, shortDesc, clubName),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: buildImage(imgUrl),
                      ),
                      Expanded(
                        child: buildRichText(
                            eventDate, title, shortDesc, clubName),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  RichText buildRichText(
      String eventDate, String title, String shortDesc, String clubName) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
          // text: 'Event Date: $eventDate',
          style: TextStyle(color: Colors.grey[400], fontSize: 15),
          children: <TextSpan>[
            TextSpan(
              text: 'Event Date: $eventDate',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
            TextSpan(
              text: '\n$title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '\n$shortDesc',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            TextSpan(
              text: '\n$clubName',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ]),
    );
  }

  Center buildImage(String imgUrl) {
    return Center(
      child: imgUrl != null && imgUrl != ''
          ? Image.network(
              imgUrl,
              height: 170,
            )
          : Icon(
              Icons.image,
              size: 100,
            ),
    );
  }
}
