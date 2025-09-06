import 'package:dio/dio.dart';

const String base = "https://ank143matkaapp.info/api/v1";
final dio = Dio();
// final dio = Dio(

//   BaseOptions(
//     baseUrl: "https://ank143matkaapp.info/api/v1/", // change this
//     headers: {"Content-Type": "application/json"},
//   ),
// );

// Signup
Future<void> signup() async {
  try {
    final response = await dio.post(
      "$base/auth/signup",
      data: {
        "user_name": "t2",
        "mobile": "9064104264",
        "email": "demo1@demo1.com",
        "password": "123456",
        "referral_code": "zysBtYpA",
        "fcm": "-",
      },
    );
    print("Signup Response: ${response.data}");
  } on DioException catch (e) {
    print("Signup Error: ${e.response?.data ?? e.message}");
  }
}

// Login

Future<void> login() async {
  try {
    final response = await dio.post(
      "$base/auth/loginmobile",
      data: {"mobile": "9064104264", "password": "123456"},
    );
    if (response.statusCode == 200) {
      print('login sucesss');
    }
    print("Login Response: ${response..data}");
  } on DioException catch (e) {
    print("Login Error: ${e.response?.data ?? e.message}");
  }
}
