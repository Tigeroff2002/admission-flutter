import 'dart:async';
import 'dart:io';

import 'package:admission_flutter/AuthorizationPage.dart';
import 'package:admission_flutter/ProfilePageWidget.dart';
import 'package:admission_flutter/models/requests/UserRegisterModelRequest.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'GlobalEndpoints.dart';

class RegisterPage extends StatefulWidget{
  @override
  RegisterPageState createState(){
    return new RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isAdmin = false;

  bool isEmailValidated = true;
  bool isFirstNameValidated = true;
  bool isSecondNameValidated = true;
  bool isPasswordValidated = true;

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    secondNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> register(BuildContext context) async {
    String firstName = firstNameController.text;
    String secondName = secondNameController.text;
    String password = passwordController.text;
    String email = emailController.text;

    var model = new UserRegisterModelRequest(
        email: email,
        password: password,
        first_name: firstName,
        second_name: secondName,
        is_admin: isAdmin);

    var requestMap = model.toJson();

    var uris = GlobalEndpoints();

    var currentUri = uris.webUri;

    var requestString = '/register';

    var currentPort = uris.currentWebPort;

    final url = Uri.parse(currentUri + currentPort + requestString);

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(requestMap);

    try {
      http.post(url ,headers: headers, body : body).then((response) async {

        if (response.statusCode == 200)
        {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Ошибка!'),
                content: Text(
                    'Регистрация не удалась!'
                        ' Пользователь с указанной почтой был уже зарегистрирован'),
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

            await Future.delayed(const Duration(milliseconds: 30000));

            MySharedPreferences mySharedPreferences = new MySharedPreferences();

            await mySharedPreferences.clearData();

            await mySharedPreferences.saveDataWithExpiration(response.body, const Duration(days: 7));

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LK()));

            firstNameController.clear();
            secondNameController.clear();
            emailController.clear();
            passwordController.clear();
          }
      });
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
          title: Text('Регистрация нового аккаунта'),
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
                controller: firstNameController,
                decoration: InputDecoration(
                    labelText: 'Имя пользователя: ',
                    labelStyle: TextStyle(
                        color: Colors.deepPurple
                    ),
                    errorText: !isFirstNameValidated
                        ? 'Имя не может быть пустым'
                        : null
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: secondNameController,
                decoration: InputDecoration(
                    labelText: 'Фамилия пользователя: ',
                    labelStyle: TextStyle(
                        color: Colors.deepPurple
                    ),
                    errorText: !isFirstNameValidated
                        ? 'Фамилия не может быть пустой'
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
              SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                checkbox(
                    title: "Вы админ?",
                    initValue: isAdmin,
                    onChanged: (sts) => setState(() => isAdmin = sts)),
              ]),
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
                    isFirstNameValidated = !firstNameController.text.isEmpty;
                    isSecondNameValidated = !secondNameController.text.isEmpty;
                    isPasswordValidated = !passwordController.text.isEmpty;

                    if (isEmailValidated && isPasswordValidated
                        && isFirstNameValidated && isSecondNameValidated){
                      register(context);
                    }
                  });
                },
                child: Text('Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget checkbox(
      {required String title, bool initValue = false, required Function(bool boolValue) onChanged}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title),
          Checkbox(value: initValue, onChanged: (b) => onChanged(b!))
        ]);
      }
}