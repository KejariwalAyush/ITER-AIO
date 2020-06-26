import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:wiredash/wiredash.dart';

class ReportBugs extends StatelessWidget {
  const ReportBugs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Wiredash.of(context).show(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              LineAwesomeIcons.bug,
              size: 40,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Report a Bug/Request a feature',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
