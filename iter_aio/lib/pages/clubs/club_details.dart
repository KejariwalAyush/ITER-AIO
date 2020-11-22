import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/pages/clubs/club_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iteraio/Utilities/Theme.dart';
import '../events/events_form.dart';
import 'package:iteraio/pages/events/event_desc.dart';

// ignore: must_be_immutable
class ClubDetails extends StatelessWidget {
  QueryDocumentSnapshot doc;
  ClubDetails({@required this.doc, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Club Profile'),
        centerTitle: true,
        elevation: 15,
        automaticallyImplyLeading: true,
        actions: [
          if (doc['coordinators'].contains(regdNo) || admin)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClubDetailsForm(
                      doc: doc,
                    ),
                  )),
            )
        ],
      ),
      floatingActionButton: !doc['coordinators'].contains(regdNo) && !admin
          ? SizedBox.shrink()
          : FloatingActionButton.extended(
              isExtended: true,
              icon: Icon(
                Icons.event_note,
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              label: Text(
                'Add an Event!',
                style: TextStyle(
                    color: brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              backgroundColor: colorDark.withOpacity(1),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventsForm(),
                    ));
              },
            ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              doc['logoUrl'] != ''
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(doc['logoUrl']),
                      maxRadius: 75,
                    )
                  : Icon(
                      Icons.group,
                      size: 75,
                    ),
              Text(
                doc['name'],
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              buildRichText(context, 'Description', doc['desc']),
              buildRichText(context, 'Instagram link', doc['instaLink']),
              buildRichText(context, 'Other links',
                  doc['otherLinks'].toString().replaceAll(' ', '\n')),
              buildRichText(context, 'How To Join?', doc['howToJoin']),
              buildRichText(context, 'Benifits', doc['benifits']),
              buildRichText(context, 'Activity', doc['activity']),
              ExpansionTile(
                title: Text('Coordinators'),
                leading: Icon(Icons.admin_panel_settings),
                children: [
                  for (var item in doc['coordinators'])
                    ListTile(
                      title: SelectableText(item),
                    ),
                ],
              ),
              ExpansionTile(
                title: Text('Events'),
                leading: Icon(Icons.event_available),
                children: [
                  StreamBuilder(
                    stream: events
                        .where('clubName', isEqualTo: doc['name'])
                        .snapshots(),
                    // initialData: initialData ,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                          // height: 200,
                          child: Text('Loading.../No events Yet'),
                        );
                      else
                        return Column(children: [
                          for (var doc in snapshot.data.docs)
                            InkWell(
                              onTap: regdNo != null
                                  ? () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EventDesc(doc: doc),
                                      ))
                                  : null,
                              child: ListTile(
                                leading: doc['imgUrl'] != ''
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(doc['imgUrl']),
                                      )
                                    : Icon(Icons.image),
                                title: Text(doc['title']),
                                subtitle: Text(doc['shortDesc']),
                                trailing: Icon(Icons.chevron_right),
                              ),
                            ),
                        ]);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRichText(BuildContext context, String _name, String _desc) {
    if (_desc == '') return SizedBox.shrink();
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white,
            ),
          ),
          if (_desc.contains('https://'))
            buildLink(_desc)
          else
            Text(
              _desc,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildLink(String links) {
    var _linkList = links.split('\n');
    return Column(
      children: [
        for (var link in _linkList)
          InkWell(
            onTap: () => _launchURL(link),
            child: Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                    text: link,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                        color: Colors.blueAccent),
                  ),
                )),
          ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return;
  }
}
