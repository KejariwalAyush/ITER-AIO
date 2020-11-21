import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/Theme.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewList extends StatefulWidget {
  final String title;
  final List list;
  ViewList({this.title, this.list, Key key}) : super(key: key);

  @override
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  GlobalKey _listContainer = new GlobalKey();
  var query = [];
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text(widget.title),
        automaticallyImplyLeading: true,
        actions: _buildActions(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        icon: Icon(
          Icons.email,
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        label: Text(
          "Write a mail to all of them",
          style: TextStyle(
              color:
                  brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
        backgroundColor: colorDark.withOpacity(1),
        onPressed: () => _launchURL(
            // 'mailto:ayush1kej@gmail.com,akej@yahoo.in,abc@gmail.com'
            'mailto:${widget.list.map((e) => e['email']).toList().toString().replaceAll('[', '').replaceAll(']', '')}'),
      ),
      body: RepaintBoundary(
        key: _listContainer,
        child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (BuildContext context, int index) {
            return buildListTile(index);
          },
        ),
      ),
    );
  }

  Widget buildListTile(int index) {
    var s = searchQuery.toLowerCase();
    var t = widget.list[index]
        .toString()
        .substring(1, widget.list[index].toString().length - 1);
    if (!_isSearching || t.toLowerCase().contains(s))
      return ListTile(
        title: Text(t.split(',')[0]),
        subtitle: Text(t.split(',')[1]),
        leading: Icon(Icons.person),
      );
    else
      return SizedBox.shrink();
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
      IconButton(
        icon: const Icon(Icons.ios_share),
        onPressed: () {
          ShareFilesAndScreenshotWidgets().shareScreenshot(
              _listContainer, 1080, "Event", "MyEvent.png", "image/png",
              text:
                  "Here is the List of Emails of intrested people of ${widget.title} Event!\n\n${widget.list.map((e) => e['email']).toList()}\n\nFind out more, Download ITER-AIO from here http://tiny.cc/iteraio");
        },
      ),
    ];
  }

  _launchURL(String url) async {
    // const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return;
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
