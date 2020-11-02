import 'package:dio/dio.dart';

class ApiProvider {
  Dio _dio;
  String aToken = '';

  final BaseOptions options = new BaseOptions(
    baseUrl: 'http://136.233.14.3:8282/CampusPortalSOA',
    connectTimeout: 15000,
    receiveTimeout: 13000,
    // contentType: 'application/json',
  );

  static final ApiProvider _instance = ApiProvider._internal();

  factory ApiProvider() => _instance;

  ApiProvider._internal() {
    _dio = Dio(options);
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) async {
      // to prevent other request enter this interceptor.
      _dio.interceptors.requestLock.lock();
      // We use a new Dio(to avoid dead lock) instance to request token.
      //Set the cookie to headers
      options.headers["cookie"] = aToken;

      _dio.interceptors.requestLock.unlock();
      return options; //continue
    }));
  }

  Future login() async {
    final request = {
      "username": "1941012408",
      "password": "29Sept00",
      "MemberType": "S"
    };
    final response = await _dio.post(
      '/login',
      data: request,
    );
    print(response.statusCode);
    print(response.data.toString());
    //get cooking from response
    final cookies = response.headers.map['set-cookie'];
    if (cookies != null) {
      final authToken =
          cookies[0]; //it depends on how your server sending cookie
      //save this authToken in local storage, and pass in further api calls.

      aToken =
          authToken; //saving this to global variable to refresh current api calls to add cookie.
      print(authToken);
    }

    print(cookies);
    return cookies;
    //print(response.headers.toString());
  }

  /// If we call this function without cookie then it will throw 500 err.
  Future getStudentInfo() async {
    final response = await _dio.post('/studentinfo');

    print(response.data.toString());
  }
}
