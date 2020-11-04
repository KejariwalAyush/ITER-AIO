import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/widgets/app_drawer.dart';

class LargeAppDrawer {
  LargeAppDrawer();

  Expanded largeDrawer(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: double.maxFinite,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Theme.of(context).appBarTheme.color, width: 3))),
        child: CustomAppDrawer(
                sresult: true, sbunk: true, slogout: true, srestart: true)
            .buildLargeNaviDrawer(context),
      ),
    );
  }
}
