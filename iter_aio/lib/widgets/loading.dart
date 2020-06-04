import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

Widget loading() {
  return new FlareActor("assets/animations/ITER-AIO.flr",
      alignment: Alignment.center, fit: BoxFit.contain, animation: "loading");
}
