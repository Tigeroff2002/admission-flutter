import 'dart:convert';
import 'dart:io';

import 'package:admission_flutter/models/requests/UserLKModelRequest.dart';
import 'package:admission_flutter/models/responses/ResponseWithToken.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'GlobalEndpoints.dart';

class LK extends StatefulWidget {

  @override
  LKState createState() => LKState();
}

final headers = {'Content-Type': 'application/json'};

class LKState extends State<LK> {
  String pictureUrl = "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg";

  String accountCreationTime = '';
  String userRole = 'User';
  String userName = '';
  String email = '';

  bool isPasswordHidden = true;
  bool isUserRole = true;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {

    MySharedPreferences mySharedPreferences = new MySharedPreferences();

    var cachedData = await mySharedPreferences.getDataIfNotExpired();

    if (cachedData != null){
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var abiturient_id = cacheContent.abiturient_id;
      var token = cacheContent.token.toString();

      var model = new UserLKModelRequest(abiturient_id: abiturient_id, token: token);
      var requestMap = model.toJson();

      var uris = GlobalEndpoints();

      var currentUri = uris.webUri;

      var requestString = '/users/get_info';

      var currentPort = uris.currentWebPort;

      final url = Uri.parse(currentUri + currentPort + requestString);

      final body = jsonEncode(requestMap);

      try {
        final response = await http.post(url, headers: headers, body: body);

        var jsonData = jsonDecode(response.body);
        var responseContent = ResponseWithToken.fromJson(jsonData);

        if (responseContent.result) {
          var userRequestedInfo = responseContent.content.toString();

          var data = jsonDecode(userRequestedInfo);

          setState(() {
            userName = data['user_name'].toString();
            userRole = data['user_role'].toString();
            //accountCreationTime = data['account_creation'].toString();
            email = data['user_email'].toString();
          });
        }
      }
      catch (e) {
        if (e is SocketException) {
          //treat SocketException
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Ошибка!'),
              content: Text('Проблема с соединением к серверу!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
        else if (e is TimeoutException) {
          //treat TimeoutException
          print("Timeout exception: ${e.toString()}");
        }
        else
          print("Unhandled exception: ${e.toString()}");
      }
    }
    else {
      setState(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Ошибка!'),
            content:
            Text(
                'Произошла ошибка при получении'
                    ' информации о пользователе!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: new ThemeData(scaffoldBackgroundColor: Colors.cyanAccent),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Профиль пользователя'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LK()),);
              },
            ),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(32),
                child: Column()
              ),
            ),
          ),
        ),
    );
  }
}