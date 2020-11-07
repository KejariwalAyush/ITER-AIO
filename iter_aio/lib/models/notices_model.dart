class NoticeContent {
  final String title;
  final String link;
  final String author;
  final String time;

  NoticeContent({this.title, this.link, this.author, this.time});

  @override
  String toString() {
    return '''{
      "title": "$title",
      "link": "$link",
      "author": "$author",
      "time": "$time"
    }''';
  }
}
