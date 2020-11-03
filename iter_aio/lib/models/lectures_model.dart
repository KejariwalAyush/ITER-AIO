import 'package:flutter/foundation.dart';

class Lecture {
  final String title;
  final String id;
  final String link1;
  final String link2;
  final String downloadLink;
  final String size;
  final int date;
  final String previewImgUrl;
  final String imageUrl;

  Lecture(
      {this.title,
      this.id,
      this.link1,
      this.link2,
      this.downloadLink,
      this.size,
      this.date,
      this.previewImgUrl,
      this.imageUrl});
}

class Subject {
  final String name;
  final String code;
  final String link;
  List<Lecture> lectures;

  Subject({this.name, this.code, this.link, this.lectures});

  addLectures(List<Lecture> lecs) {
    this.lectures = lecs;
  }
}

class CourseLectures {
  final String course;
  final List<Subject> subjects;

  CourseLectures({@required this.course, @required this.subjects});
}
