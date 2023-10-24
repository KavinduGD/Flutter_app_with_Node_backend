import 'package:app/screen/dashboard.dart';
import 'package:app/screen/registration.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token;
  if (prefs.getString("token") == null) {
    token = "";
  } else {
    token = prefs.getString("token")!;
  }

  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final String token;

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    Widget activeScreen;
    if (token == "") {
      activeScreen = Registration();
    } else if (JwtDecoder.isExpired(token) == true) {
      activeScreen = Registration();
    } else {
      activeScreen = Dashboard(
        token: token,
      );
    }
    print(token);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: activeScreen,
    );
  }
}
