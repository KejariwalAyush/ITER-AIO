import 'package:flutter/material.dart';
import 'package:iteraio/helper/attendance_fetch.dart';
import 'package:iteraio/helper/lectures_fetch.dart';
import 'package:iteraio/helper/login_fetch.dart';
import 'package:iteraio/helper/profile_fetch.dart';
import 'package:iteraio/helper/result_fetch.dart';

var appStarted = true;
bool noInternet = false;
bool serverTimeout = false;
Brightness brightness = Brightness.dark;

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
String themeStr;
bool isLoggedIn;
