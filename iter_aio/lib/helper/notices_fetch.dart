import 'package:html/parser.dart';
import 'package:iteraio/models/notices_model.dart';
import 'package:iteraio/helper/session.dart';

class NoticesFetch {
  final soaUrl = 'https://www.soa.ac.in';
  List<NoticeContent> finalIterNotices = [];
  List<NoticeContent> finalIterExamNotices = [];
  List<NoticeContent> finalSoaNotices = [];

  NoticesFetch() {
    _saveFinalIterNotices();
    _saveFinalIterExamNotices();
    _saveFinalSoaNotices();
  }

  void _saveFinalIterNotices() async {
    finalIterNotices = await _fetchIterNotices() as List<NoticeContent>;
  }

  void _saveFinalIterExamNotices() async {
    finalIterExamNotices = await _fetchIterExamNotices() as List<NoticeContent>;
  }

  void _saveFinalSoaNotices() async {
    finalSoaNotices = await _fetchSoaNotices() as List<NoticeContent>;
  }

  Future<List<NoticeContent>> getIterNotices() async {
    if (finalIterNotices != null) {
      return finalIterNotices;
    } else
      return await _fetchIterNotices();
  }

  Future<List<NoticeContent>> getIterExamNotices() async {
    if (finalIterExamNotices != null) {
      return finalIterExamNotices;
    } else
      return await _fetchIterExamNotices();
  }

  Future<List<NoticeContent>> getSoaNotices() async {
    if (finalSoaNotices != null) {
      return finalSoaNotices;
    } else
      return await _fetchSoaNotices();
  }

  Future _fetchIterNotices() async {
    List<NoticeContent> _iterNotices = [];
    var body = await Session().getReq(soaUrl + '/iter-student-notice/');
    var doc = parse(body);
    var links = doc.querySelectorAll('main > section > section > article');
    for (var link in links) {
      _iterNotices.add(NoticeContent(
        title: link.querySelector('a').text,
        link: soaUrl + link.querySelector('a').attributes['href'],
        author: link.querySelector('div > a').text,
        time: link.querySelector('div > time').text,
      ));
      // _iterNotices.add(content);
      // print(content);
    }
    return _iterNotices;
  }

  Future _fetchIterExamNotices() async {
    List<NoticeContent> _iterExamNotices = [];
    var body = await Session().getReq(soaUrl + '/iter-exam-notice/');
    var doc = parse(body);
    var links = doc.querySelectorAll('main > section > section > article');
    for (var link in links) {
      var content = NoticeContent(
        title: link.querySelector('a').text,
        link: soaUrl + link.querySelector('a').attributes['href'],
        author: link.querySelector('div > a').text,
        time: link.querySelector('div > time').text,
      );
      _iterExamNotices.add(content);
    }
    return _iterExamNotices;
  }

  Future _fetchSoaNotices() async {
    List<NoticeContent> _soaNotices = [];
    var body = await Session().getReq(soaUrl + '/general-notifications/');
    var doc = parse(body);
    var links = doc.querySelectorAll('main > section > section > article');
    for (var link in links) {
      var content = NoticeContent(
        title: link.querySelector('a').text,
        link: soaUrl + link.querySelector('a').attributes['href'],
        author: link.querySelector('div > a').text,
        time: link.querySelector('div > time').text,
      );
      _soaNotices.add(content);
    }
    return _soaNotices;
  }
}
