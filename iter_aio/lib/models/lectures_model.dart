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

  @override
  String toString() {
    return '''{
      "title": "$title",
      "id": "$id",
      "link1": "$link1",
      "link2": "$link2",
      "downloadLink": "$downloadLink",
      "size": "$size",
      "previewImgUrl": "$previewImgUrl",
      "imageUrl": "$imageUrl",
      "date": $date
    }''';
  }
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

  @override
  String toString() {
    return '''{
      "name": "$name",
      "code": "$code",
      "link": "$link",
      "lectures": [${_lecturesString()}]
    }''';
  }

  String _lecturesString() {
    var s = '';
    for (var i in lectures) s += i.toString() + ',';
    return s.substring(0, s.lastIndexOf(','));
  }
}

class CourseLectures {
  final String course;
  final List<Subject> subjects;

  CourseLectures({@required this.course, @required this.subjects});

  @override
  String toString() {
    return '''{
      "course": "$course",
      "subjects": [${_subjectsString()}]
    }''';
  }

  String _subjectsString() {
    var s = '';
    for (var i in subjects) s += i.toString() + ',';
    return s.substring(0, s.lastIndexOf(','));
  }
}
