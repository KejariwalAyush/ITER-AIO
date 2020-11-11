import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iteraio/pages/events/view_list.dart';
import 'package:iteraio/widgets/show_notification.dart';

class EventDesc extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  EventDesc({Key key, this.doc}) : super(key: key);

  @override
  _EventDescState createState() => _EventDescState();
}

class _EventDescState extends State<EventDesc> {
  bool isIntrested = false;
  var intrestedButton = 'I\'m Intrested';
  List intrestedList;
  List views;

  @override
  void initState() {
    setState(() {
      // print(widget.doc['views'].toString());
      views = widget.doc['views'].toList();
      if (views != null && !views.contains(regdNo)) {
        views.add(regdNo);
        events.doc(widget.doc.id).update({'views': views});
      }

      // print(widget.doc['views'].toString());
      intrestedList = widget.doc['intrested'].toList();
      // print(intrestedList.toString().contains(regdNo));
      if (intrestedList.toString().contains(regdNo))
        intrestedButton = 'You are intrested!';
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Description',
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          if (admin && regdNo == widget.doc['adminRegdNo'])
            IconButton(
              icon: Icon(Icons.delete_forever),
              tooltip: 'Delete this Event',
              onPressed: () {
                events.doc(widget.doc.id).delete().then((value) {
                  print("Event Deleted");
                  Notify().showNotification(
                      title: 'Event Deleted!',
                      body: 'Event Deleted Sucessessful');
                  Navigator.pop(context);
                }).catchError(
                    (error) => print("Failed to delete user: $error"));
              },
            )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        icon: Icon(
          Icons.local_fire_department,
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        label: Text(
          intrestedButton,
          style: TextStyle(
              color:
                  brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
        backgroundColor: colorDark.withOpacity(1),
        onPressed: () {
          if (intrestedList.toString().contains(regdNo))
            setState(() {
              intrestedButton = 'You are Intrested!';
              isIntrested = true;
            });
          else
            setState(() {
              intrestedList.add({regdNo: name});
              events
                  .doc(widget.doc.id)
                  .update({'intrested': intrestedList}).then((value) {
                setState(() {
                  intrestedButton = 'You are Intrested!';
                  isIntrested = true;
                });
                return 'sucess';
              });
            });
        },
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton.icon(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {},
                    label: Text('${widget.doc['views'].length} views'),
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.local_fire_department),
                    onPressed: () {},
                    label: Text('${widget.doc['intrested'].length} intrested'),
                  ),
                ],
              ),
              buildImage(),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.doc['title'],
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.doc['clubName'],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              buildHeadingWithDesc('Description', widget.doc['desc']),
              if (widget.doc['link'] != '') buildLink(),
              buildHeadingWithDesc(
                  'Date & Time Of the Event',
                  new DateFormat.jm()
                      .add_yMMMMEEEEd()
                      .format(widget.doc['eventDate'].toDate())),
              Text(
                'Event Length : ${widget.doc['eventDays']} day(s)',
                textAlign: TextAlign.start,
              ),
              buildHastags(),
              buildHeadingWithDesc(
                  'Published On',
                  new DateFormat.yMMMMEEEEd()
                      .format(widget.doc['time'].toDate())),
              buildHeadingWithDesc('Published by', widget.doc['adminName']),
              if (admin)
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewList(
                              title: 'Event Intrested List',
                              list: intrestedList),
                        )),
                    child: ListTile(
                      title: Text('List of Intrested peoples'),
                      leading: Icon(Icons.list),
                    )),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildHastags() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child: Text(
              'Hashtags',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        Container(
          padding: EdgeInsets.all(10),
          child: Wrap(
            children: [
              for (var hashtag in widget.doc['hashtags'])
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: colorDark.withOpacity(1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    hashtag,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLink() {
    return InkWell(
      onTap: () => _launchURL(widget.doc['link']),
      child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(10),
          child: RichText(
            overflow: TextOverflow.fade,
            text: TextSpan(
                text: 'Link : ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: widget.doc['link'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                        color: Colors.blueAccent),
                  )
                ]),
          )),
    );
  }

  Widget buildImage() {
    if (widget.doc['imgUrl'] == '') return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      height: 300,
      margin: EdgeInsets.all(5),
      child: Image.network(
        widget.doc['imgUrl'],
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Text(
            'Error Loading the Image!',
            style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget buildHeadingWithDesc(String title, String desc) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Text(desc),
          ),
        ],
      ),
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
