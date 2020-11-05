class SubjectAttendance {
  final rawData;
  final String bunkText;
  final int sem;
  final double totAtt;
  final String latt;
  final String patt;
  final String tatt;
  final double lattper;
  final double pattper;
  final double tattper;
  final String subject;
  final int present;
  final int absent;
  final int classes;
  final String subjectCode;
  final DateTime lastUpdatedOn;

  SubjectAttendance(
      {this.sem,
      this.rawData,
      this.bunkText,
      this.classes,
      this.present,
      this.absent,
      this.totAtt,
      this.latt,
      this.patt,
      this.tatt,
      this.tattper,
      this.lattper,
      this.pattper,
      this.subject,
      this.subjectCode,
      this.lastUpdatedOn});

  String toString() {
    return '''{
      "rawData": "$rawData",
      "sem": "$sem",
      "bunkText": "${bunkText.toString()}", 
      "classes": "$classes",
      "present": "$present", 
      "absent": "$absent", 
      "totAtt": "$totAtt", 
      "latt": "$latt", 
      "patt": "$patt", 
      "tatt": "$tatt", 
      "lattper": "$lattper", 
      "pattper": "$pattper", 
      "tattper": "$tattper", 
      "subject": "$subject", 
      "subjectCode": "$subjectCode", 
      "lastUpdatedOn": "$lastUpdatedOn"
    }''';
  }
}

class AttendanceInfo {
  final List<SubjectAttendance> data;
  final double avgAttPer;
  final int avgAbsPer;
  final bool attendAvailable;

  AttendanceInfo(
      {this.attendAvailable, this.data, this.avgAbsPer, this.avgAttPer});

  String toString() {
    return '''{
      "data": [${_getSubjectAtt()}],
      "avgAttPer": "$avgAttPer",
      "avgAbsPer": "$avgAbsPer",
      "attendAvailable": "$attendAvailable"}''';
  }

  String _getSubjectAtt() {
    String st;
    for (var i in data) st += i.toString() + ',';
    return st.substring(0, st.lastIndexOf(','));
  }
}
