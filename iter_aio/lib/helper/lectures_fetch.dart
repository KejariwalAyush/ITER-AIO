import 'dart:convert';

import 'package:iteraio/models/lectures_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class LecturesFetch {
  int semNo;
  List<CourseLectures> finalLectures;

  LecturesFetch({@required this.semNo}) {
    _saveFinalLectures();
  }

  void _saveFinalLectures() async {
    finalLectures = await _fetchCourses() as List<CourseLectures>;
    // print(finalLectures[0].subjects[0].name);
  }

  Future<List<CourseLectures>> getCourse() async {
    if (finalLectures != null) {
      return finalLectures;
    } else {
      finalLectures = await _fetchCourses();
      return finalLectures;
    }
  }

  Future<List<Lecture>> getLecture(Subject subject) async {
    if (subject.lectures == null) {
      List<Lecture> _lecs = await _getSubjectLecture(subject.link);
      subject.addLectures(_lecs);
      return _lecs;
    } else
      return subject.lectures;
  }

  Future _fetchCourses() async {
    List<CourseLectures> lecturesData = [];
    print('loading Lecturess on helper...');

    var response;
    if (semNo == 2 || semNo == 1)
      response = await http.get("https://www.soa.ac.in/2nd-semester");
    else if (semNo == 4 || semNo == 3)
      response = await http.get(
          "https://www.soa.ac.in/btech-4th-semester-online-video-lectures");
    else if (semNo == 6 || semNo == 5)
      response = await http.get(
          "https://www.soa.ac.in/btech-6th-semester-online-video-lectures");
    else if (semNo == 7 || semNo == 8)
      response = await http.get(
          "https://www.soa.ac.in/btech-8th-semester-online-video-lectures");
    else
      response = await http.get(
          "https://www.soa.ac.in/btech-4th-semester-online-video-lectures");

    if (response.statusCode == 200) {
      var document = parse(response.body);
      var links = document.getElementsByClassName('Index-page-content');
      for (var link in links) {
        lecturesData.add(CourseLectures(
          course: link
              .getElementsByClassName('sqs-block html-block sqs-block-html')[0]
              .text,
          subjects: await _getSubjects(link),
        ));
      }
    }

    return lecturesData.toList();
  }

  Future<List<Subject>> _getSubjects(var link) async {
    List<Subject> subjectsData = [];

    for (int i = 0; i < link.querySelectorAll('p').length - 2; i += 3)
      subjectsData.add(Subject(
        name: link.querySelectorAll('p')[i].text,
        code: link.querySelectorAll('p')[i + 1].text,
        link: link
            .querySelectorAll('p')[i + 2]
            .querySelector('a')
            .attributes['href'],
        // lectures: await _getLecture(link
        //     .querySelectorAll('p')[i + 2]
        //     .querySelector('a')
        //     .attributes['href']),
      ));
    return subjectsData.toList();
  }

  Future<List<Lecture>> _getSubjectLecture(String url) async {
    List<Lecture> lecData = [];

    var pageno = 0;
    var pagecount = 1;
    while (pagecount > pageno) {
      pageno++;
      final resp2 = await http
          .get('$url?page=$pageno&sortColumn=name&sortDirection=DESC');
      if (resp2.statusCode == 200) {
        var doc = parse(resp2.body);
        var links2 = doc.querySelectorAll('html > body > script');
        var data1 = links2[links2.length - 1].text.substring(
            links2[links2.length - 1].text.indexOf('{'),
            links2[links2.length - 1].text.length - 1);
        var data2 = jsonDecode(data1).values.toList()[1];
        pageno = data2['pageNumber'];
        pagecount = data2['pageCount'];
        for (var i in data2['items']) {
          lecData.add(Lecture(
            title: i['name'],
            id: i['id'].toString(),
            link1:
                'https://m.box.com/shared_item/${url.replaceAll('/', '%2F').replaceFirst(':', '%3A')}/view/${i['id']}',
            link2:
                'https://m.box.com/${i['type']}/${i['id']}/${url.replaceAll('/', '%2F').replaceFirst(':', '%3A')}/preview/preview.mp4',
            size: (i['itemSize'] / (1024 * 1024)).round().toString(),
            date: i['date'],
            imageUrl: i['thumbnailURLs']['large'],
            previewImgUrl: i['thumbnailURLs']['preview'],
          ));
        }
      }
    }

    return lecData.toList();
  }
}
