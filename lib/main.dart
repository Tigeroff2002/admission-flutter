import 'package:admission_flutter/AuthorizationPage.dart';
import 'package:admission_flutter/HomePage.dart';
import 'package:admission_flutter/LoginPage.dart';
import 'package:admission_flutter/LKWidget.dart';
import 'package:admission_flutter/RegisterPage.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Приложение для абитуриентов',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthorizationPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/lk': (context) => LK(),
/*         '/adminLK': (context) => UserInfoMapPage(),
        '/directions': (context) => DirectionsPage(),
        'direction/:id' (context) => SingleDirectionPage() */
      },
    );
  }
}