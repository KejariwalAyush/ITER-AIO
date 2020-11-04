class SubjectAttendance {
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
  final String subjectCode;
  final DateTime lastUpdatedOn;

  SubjectAttendance(
      {this.sem,
      this.bunkText,
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
}

class AttendanceInfo {
  final List<SubjectAttendance> data;
  final double avgAttPer;
  final int avgAbsPer;
  final bool attendAvailable;

  AttendanceInfo(
      {this.attendAvailable, this.data, this.avgAbsPer, this.avgAttPer});
}

// "stynumber": 3,
//             "TotalAttandence": 100.0,
//             "Latt": "Not Applicable",
//             "Patt": "12 / 12",
//             "subject": "Computer Science Workshop 1",
//             "Tatt": "0 / 0",
//             "subjectcode": "CSE2141",
//             "lastupdatedon": "03/11/2020 10:09 PM"
