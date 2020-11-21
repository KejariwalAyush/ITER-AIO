import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iteraio/components/splash_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:iteraio/Utilities/global_var.dart';

class PushMessagingExample extends StatefulWidget {
  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();
}

class _PushMessagingExampleState extends State<PushMessagingExample> {
  // ignore: unused_field
  String _homeScreenText = "Waiting for token...";
  // String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onMessage: $message");
        showSimpleNotification(
          Container(child: Text(message['notification']['title'])),
          position: NotificationPosition.top,
        );
        Alert(
                context: context,
                title: message['notification']['title'],
                type: AlertType.none,
                onWillPopActive: true,
                desc: message['notification']['body'])
            .show();
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     content: ListTile(
        //       title: Text(message['notification']['title']),
        //       subtitle: Text(message['notification']['body']),
        //     ),
        //     actions: <Widget>[
        //       FlatButton(
        //         child: Text('Ok'),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //     ],
        //   ),
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        // setState(() {
        //   _messageText = "Push Messaging message: $message";
        // });
        print("onResume: $message");
      },
    );
    //  _firebaseMessaging.requestNotificationPermissions(
    //      const IosNotificationSettings(sound: true, badge: true, alert: true));
    //  _firebaseMessaging.onIosSettingsRegistered
    //      .listen((IosNotificationSettings settings) {
    //    print("Settings registered: $settings");
    //  });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
        users
            .doc(regdNo)
            .update({'fcmToken': token})
            .then((value) => print("FCM token Updated"))
            .catchError((error) => print("Failed to update token: $error"));
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}
