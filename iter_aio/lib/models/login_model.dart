class LoginData {
  String regdNo;
  String password;
  String cookie;
  String message;
  String status;
  String name;

  LoginData(
      {this.regdNo,
      this.password,
      this.cookie,
      this.message,
      this.status,
      this.name});

  void addCredentials(String regd, String pass) {
    this.regdNo = regd;
    this.password = pass;
  }

  String toString() {
    return '''{
      "regdNo": "$regdNo",
      "password": "$password",
      "cookie": "$cookie",
      "message": "$message",
      "status": "$status",
      "name": "$name"
    }''';
  }
}
