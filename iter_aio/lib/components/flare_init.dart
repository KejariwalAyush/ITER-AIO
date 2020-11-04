import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Flare extends StatefulWidget {
  @override
  _FlareState createState() => _FlareState();
}

class _FlareState extends State<Flare> {
  @override
  Widget build(BuildContext context) {
    return new FlareActor("assets/animations/ITER-AIO.flr",
        alignment: Alignment.center, fit: BoxFit.contain, animation: "entry");
  }
}
