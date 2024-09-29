import 'package:admission_flutter/HomePage.dart';
import 'package:admission_flutter/LoginPage.dart';
import 'package:admission_flutter/RegisterPage.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthorizationPage extends StatefulWidget {

  @override
  AuthorizationPageState createState() {
    return new AuthorizationPageState();
  }
}

class AuthorizationPageState extends State<AuthorizationPage> {

  MySharedPreferences mySharedPreferences = new MySharedPreferences();

  String? cachedData = null;

  @override
  void initState(){

    mySharedPreferences.getDataIfNotExpired().then((value) => cachedData = value);

    if (cachedData != null) {
      Future(() {
        Navigator.of(context).pushNamed('/lk');
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: Colors.cyanAccent),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Страница авторизации',
            style: TextStyle(fontSize: 16, color: Colors.deepPurple),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Авторизация',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Регистрация',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}