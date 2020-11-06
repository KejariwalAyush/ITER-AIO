class DetailedResult {
  final int sem;
  final String subjectCode;
  final int earnedCredit;
  final String subjectName;
  final String subjectShortName;
  final String grade;

  DetailedResult(
      {this.sem,
      this.subjectCode,
      this.earnedCredit,
      this.subjectName,
      this.subjectShortName,
      this.grade});

  String toString() {
    return '''{
    "sem": $sem,
    "subjectCode": "$subjectCode",
    "subjectName": "$subjectName",
    "subjectShortName": "$subjectShortName",
    "earnedCredit": $earnedCredit,
    "grade": "$grade"}''';
  }
}

class CGPASemResult {
  final int sem;
  final double sgpa;
  final int creditEarned;
  final bool fail;
  final bool underHold;
  final bool deactive;
  final List<DetailedResult> details;

  CGPASemResult(
      {this.sem,
      this.sgpa,
      this.creditEarned,
      this.fail,
      this.underHold,
      this.deactive,
      this.details});

  String toString() {
    return '''{
    "sem": $sem,
    "sgpa": $sgpa,
    "creditsearned": $creditEarned,
    "fail": ${fail == true},
    "underHold": ${underHold == true},
    "deactive": ${deactive == true},
    "details": [${_detailsString()}]}''';
  }

  String _detailsString() {
    var s = '';
    for (var i in details) s += i.toString() + ',';
    return s.substring(0, s.lastIndexOf(','));
  }
}
