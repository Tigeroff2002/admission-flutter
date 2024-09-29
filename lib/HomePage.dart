import 'dart:convert';

import 'package:admission_flutter/AuthorizationPage.dart';
import 'package:admission_flutter/LKWidget.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var mySharedPreferences = new MySharedPreferences();

    var cachedData = mySharedPreferences.getDataIfNotExpired();

    cachedData.then((value) {
      print(value);
    });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(scaffoldBackgroundColor: Colors.cyanAccent),
        home: Scaffold(
          appBar: AppBar(
              title: Text(
                'Приложение для абитуриентов',
                style: TextStyle(fontSize: 16, color: Colors.deepPurple),
              ),
              backgroundColor: Colors.cyan,
              centerTitle: true),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MySharedPreferences mySharedPreferences =
                        new MySharedPreferences();

                    var cachedData = mySharedPreferences.getDataIfNotExpired();

                    cachedData.then((value) {
                      if (value == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthorizationPage()));
                      }
                      var json = jsonDecode(value.toString());

                      var existedUser = json['user_id'];

                      existedUser == null
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthorizationPage()),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LK()));
                    });
                  },
                  child: Text(
                    'Стартуем',
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}