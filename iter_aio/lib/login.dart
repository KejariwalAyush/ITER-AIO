import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './MyHomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                Center(
                  child: Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  initialValue: regdNo,
                  onChanged: (String str) {
                    regdNo = str;
                  },
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Regd No.',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  autofocus: false,
                  initialValue: password,
                  onChanged: (String str) {
                    password = str;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
                      print('$regdNo : $password');
                      attendData = null;
                      resultData = null;
                      name = null;
                      sem = null;
                      infoData = null;

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyHomePage()));
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.purple[300],
                    child:
                        Text('Log In', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//final logo = Hero(
//  tag: 'hero',
//  child: CircleAvatar(
//    backgroundColor: Colors.transparent,
//    radius: 48.0,
//    child: Image.asset('assets/logo.png'),
//  ),
//);
