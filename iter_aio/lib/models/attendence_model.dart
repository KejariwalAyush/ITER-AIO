class Attendence {
  final DateTime initialTime;

  Attendence(this.initialTime);
}

// ignore: unused_element
double _getPercentage(String x) {
  return (int.parse(x.split('/')[0].trim()) /
      int.parse(x.split('/')[1].trim()) *
      100);
}
