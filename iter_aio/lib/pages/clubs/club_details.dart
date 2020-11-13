import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:url_launcher/url_launcher.dart';

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
          if (doc['coordinators'].contains(regdNo))
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            )
        ],
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
                      Icons.broken_image,
                      size: 50,
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
              buildRichText(context, 'How To Join?', doc['howToJoin']),
              buildRichText(context, 'Benifits', doc['benifits']),
              buildRichText(context, 'Activity', doc['activity']),
              buildRichText(
                  context, 'Coordinators:', doc['coordinators'].toString()),
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

  Widget buildLink(String link) {
    return InkWell(
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
