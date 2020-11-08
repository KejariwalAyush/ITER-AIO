import 'package:flutter/material.dart';
import 'package:iteraio/Utilities/global_var.dart';
import 'package:iteraio/widgets/app_drawer.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomAppDrawer(
              sresult: true, sbunk: true, slogout: true, srestart: true)
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
              onPressed: () {},
            ),
        ],
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          // bottomRight: Radius.circular(25)
        )),
      ),
      body: Container(),
    );
  }
}
