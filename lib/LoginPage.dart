import 'dart:async';
import 'dart:io';
import 'package:admission_flutter/AuthorizationPage.dart';
import 'package:admission_flutter/GlobalEndpoints.dart';
import 'package:admission_flutter/ProfilePageWidget.dart';
import 'package:admission_flutter/models/requests/UserLoginModelRequest.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState(){
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmailValidated = true;
  bool isPasswordValidated = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    var model = new UserLoginModelRequest(
        email: email,
        password: password);

    var requestMap = model.toJson();

    var uris = GlobalEndpoints();

    bool isMobile = Theme.of(context).platform == TargetPlatform.android;

    var currentUri = uris.webUri;

    var requestString = '/login';

    var currentPort = uris.currentWebPort;

    final url = Uri.parse(currentUri + currentPort + requestString);

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode(requestMap);

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {

        var jsonData = jsonDecode(response.body);

        MySharedPreferences mySharedPreferences = new MySharedPreferences();

        await mySharedPreferences.clearData();

        print(response.body);

        await mySharedPreferences.saveDataWithExpiration(response.body, const Duration(days: 7));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LK()),
        );
        emailController.clear();
        passwordController.clear();

      } else if (response.statusCode == 400){
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Ошибка!'),
            content: Text('Вы ввели неверную почту или пароль!'
                ' Удостоверьтесь, что аккаунт существует'),
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
      else{
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

      passwordController.clear();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Colors.cyanAccent),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Вход в ваш аккаунт'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthorizationPage()),);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Электронная почта: ',
                    labelStyle: TextStyle(
                      color: Colors.deepPurple
                    ),
                    errorText: !isEmailValidated
                        ? 'Почта не может быть пустой'
                        : null
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Пароль: ',
                    labelStyle: TextStyle(
                        color: Colors.deepPurple
                    ),
                    errorText: !isPasswordValidated
                        ? 'Пароль не может быть пустым'
                        : null
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor : Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0)),
                  minimumSize: Size(150, 60),
                ),
                onPressed: () async {
                  setState(() {
                    isEmailValidated = !emailController.text.isEmpty;
                    isPasswordValidated = !passwordController.text.isEmpty;

                    if (isEmailValidated && isPasswordValidated){
                      login(context);
                    }
                  });
                },
                child: Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}