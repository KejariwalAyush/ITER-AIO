import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/widgets/app_drawer.dart';
import 'package:iteraio/pages/events/events_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iteraio/widgets/loading.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:intl/intl.dart';
import 'package:iteraio/pages/events/event_desc.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  var query = [];
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

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
        title: _isSearching ? _buildSearchField() : Text('Events'),
        centerTitle: true,
        leading: _isSearching
            ? const BackButton()
            : MediaQuery.of(context).size.width > 700
                ? SizedBox()
                : Builder(
                    builder: (context) => IconButton(
                      icon: new Icon(Icons.apps),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
        actions: _buildActions(),
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(35),
                // bottomRight: Radius.circular(25)
                )),
      ),
      body: Container(
        child: StreamBuilder(
            stream: events.orderBy('eventDate', descending: false).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Container(height: 200, child: loading());
              else
                return ListView(
                    children: snapshot.data.docs.map((doc) {
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDesc(doc: doc),
                        )),
                    child: TweenAnimationBuilder(
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
                                      .format(doc['eventDate'].toDate()),
                                  doc['hashtags']),
                            )),
                  );
                }).toList());
            }),
      ),
    );
  }

  Widget buildEventTile(String imgUrl, String title, String shortDesc,
      String clubName, String eventDate, List hashtags) {
    var s = searchQuery.toLowerCase();
    if (!_isSearching ||
        title.toLowerCase().contains(s) ||
        clubName.toLowerCase().contains(s) ||
        eventDate.toLowerCase().contains(s) ||
        hashtags.contains(s))
      return Column(
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
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                buildClubName(clubName),
                buildEventDate(eventDate),
                buildImage(imgUrl),
                buildRichText(title, shortDesc)
              ],
            ),
          ),
        ],
      );
    return SizedBox.shrink();
  }

  Widget buildClubName(String clubName) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
            color: colorDark.withOpacity(1),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          '$clubName',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Text buildEventDate(String eventDate) {
    return Text(
      'Event Date: $eventDate',
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
    );
  }

  RichText buildRichText(String title, String shortDesc) {
    return RichText(
      textAlign: TextAlign.start,
      overflow: TextOverflow.clip,
      text: TextSpan(
          // style: TextStyle(color: Colors.grey[400], fontSize: 15),
          children: <TextSpan>[
            TextSpan(
              text: '\n$title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '\n$shortDesc',
              style: TextStyle(fontSize: 16),
            ),
            // TextSpan(
            //   text: '\n\n$clubName',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            // ),
          ]),
    );
  }

  Container buildImage(String imgUrl) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: imgUrl != null && imgUrl != ''
            ? Image.network(
                imgUrl,
                height: 170,
              )
            : SizedBox.shrink(),
        // : Icon(
        //     Icons.image,
        //     size: 100,
        //   ),
      ),
    );
  }

  /// search query methods
  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
      if (admin)
        IconButton(
          icon: Icon(Icons.add_box),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventsForm(),
              )),
        ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
