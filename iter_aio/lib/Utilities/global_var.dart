import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iteraio/helper/attendance_fetch.dart';
import 'package:iteraio/helper/lectures_fetch.dart';
import 'package:iteraio/helper/login_fetch.dart';
import 'package:iteraio/helper/notices_fetch.dart';
import 'package:iteraio/helper/profile_fetch.dart';
import 'package:iteraio/helper/result_fetch.dart';
import 'package:iteraio/models/attendance_info.dart';
import 'package:iteraio/models/profile_info_model.dart';
import 'package:iteraio/models/result_model.dart';

var appStarted = true;
bool noInternet = false;
bool serverTimeout = false;
bool isLoggedIn = false;
bool serverError = false;
bool firebaseSignedIn = false;

Brightness brightness = Brightness.dark;
bool isMobile;

/// for Update
String appName = 'ITER-AIO';
String packageName;
String version = '1.0';
String buildNumber;
String updatelink;
String latestversion;
bool isUpdateAvailable = false;
var updateText = "New Update is Here!";

/// for helper
var cookie;
final mainUrl = "http://136.233.14.3:8282/CampusPortalSOA";
NoticesFetch nf;
LoginFetch loginFetch;
AttendanceFetch af;
ResultFetch rf;
ProfileFetch pi;
LecturesFetch lf;

/// for login
String regdNo;
String password;
String name;
String branch;
String gender;
int sem;
String emailId;
String imgUrl;
String themeStr;
DateTime initTime;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
GlobalKey logo = new GlobalKey();

CollectionReference users = FirebaseFirestore.instance.collection('users');
CollectionReference events = FirebaseFirestore.instance.collection('events');
CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');
CollectionReference googleUsers =
    FirebaseFirestore.instance.collection('googleUser');

bool admin = false;
List<String> clubsName = [];
List<String> clubsDoc = [];

AttendanceInfo oldai;
List<CGPASemResult> oldres;
ProfileInfo oldpi;

bool isAttUpdated;
