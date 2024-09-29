import 'dart:convert';
import 'dart:io';
import 'package:admission_flutter/AuthorizationPage.dart';
import 'package:admission_flutter/GlobalEndpoints.dart';
import 'package:admission_flutter/models/requests/UserLKModelRequest.dart';
import 'package:admission_flutter/models/requests/UserLogoutModelRequest.dart';
import 'package:admission_flutter/models/responses/ResponseWithToken.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class LK extends StatefulWidget {
  @override
  LKState createState() => LKState();
}

class LKState extends State<LK> {
  String name = '';
  List<dynamic> directionsLinks = [];
  String profilePictureUrl = "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg";
  bool isAdmin = false;
  bool showDirectionForm = false;
  String directionName = '';
  String budgetPlaces = '';
  String minBall = '';
  String formError = '';

  MySharedPreferences mySharedPreferences = new MySharedPreferences();

  @override
  void initState() {
    super.initState();

    mySharedPreferences.getDataIfNotExpired().then((value) {
      if (value == null) {
        Future(() {
          Navigator.of(context).pushNamed('/');
        });
      }      
    });

    getUserData();
  }

  Future<void> getUserData() async {
    mySharedPreferences.getDataIfNotExpired().then((cachedData) async {
      
    var json = jsonDecode(cachedData.toString());
    var cacheContent = ResponseWithToken.fromJson(json);

    var abiturient_id = cacheContent.abiturient_id;
    var token = cacheContent.token;

    var model = new UserLKModelRequest(abiturient_id: abiturient_id, token: token);
    var requestMap = model.toJson();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/lk'),
        body: jsonEncode(requestMap),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['result'] == true) {
          final content = data['content'];
          setState(() {
            name = "${content['first_name']} ${content['second_name']}";
            directionsLinks = content['directions_links'] ?? [];
            isAdmin = data['is_admin'] ?? false;
          });
        } else {
          print("Error fetching user data:");
          //Navigator.pushReplacementNamed(context, '/');
        }
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }      
    });
  }

  void toggleDirectionForm() {
    setState(() {
      showDirectionForm = !showDirectionForm;
    });
  }

  void handleSubmitDirection() async {
    if (directionName.isEmpty) {
      setState(() {
        formError = 'Название направления не должно быть пустым';
      });
      return;
    }
    if (int.tryParse(budgetPlaces) == null || int.parse(budgetPlaces) < 4 || int.parse(budgetPlaces) > 20) {
      setState(() {
        formError = 'Кол-во бюджетных мест должно быть в отрезке от 4 до 20';
      });
      return;
    }
    if (int.tryParse(minBall) == null || int.parse(minBall) < 40 || int.parse(minBall) > 80) {
      setState(() {
        formError = 'Минимальный балл должен быть в отрезке от 40 до 80';
      });
      return;
    }

    mySharedPreferences.getDataIfNotExpired().then((cachedData) async{
      try{
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var abiturient_id = cacheContent.abiturient_id;
      var token = cacheContent.token;

      final response = await http.post(
        Uri.parse('http://localhost:8000/directions/addNew'),
        body: jsonEncode({
          'direction_caption': directionName,
          'budget_places_number': budgetPlaces,
          'min_ball': minBall,
          'abiturient_id': abiturient_id,
          'token': token,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == true) {
          String directionId = data['direction_id'].toString();
          Navigator.pushNamed(context, '/direction/$directionId');
        } else {
          setState(() {
            formError = data['failure_message'] ?? 'Не получилось добавить направление';
          });
        }
      }
    } catch (error) {
      setState(() {
        formError = 'Error with API request';
      });
    }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Панель администратора' : 'Личный кабинет пользователя'),
        centerTitle: true,
        leading: IconButton(
          icon: Text('Выйти'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profilePictureUrl),
            ),
            SizedBox(height: 20),
            Text(
              isAdmin ? 'Панель админа, $name' : 'Добро пожаловать, $name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            isAdmin
                ? Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to Admin Page
                          Navigator.pushNamed(context, '/adminLK');
                        },
                        child: Text('Перейти на страницу админа'),
                      ),
                      ElevatedButton(
                        onPressed: toggleDirectionForm,
                        child: Text(showDirectionForm ? 'Скрыть форму' : 'Добавить новое нправление'),
                      ),
                      if (showDirectionForm)
                        Column(
                          children: [
                            if (formError.isNotEmpty)
                              Text(formError, style: TextStyle(color: Colors.red)),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Название нправления'),
                              onChanged: (value) => directionName = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Кол0во бюджетных мест'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => budgetPlaces = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Минимальный балл'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => minBall = value,
                            ),
                            ElevatedButton(
                              onPressed: handleSubmitDirection,
                              child: Text('Отправить'),
                            ),
                          ],
                        ),
                    ],
                  )
                : directionsLinks.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: directionsLinks.length,
                          itemBuilder: (context, index) {
                            final item = directionsLinks[index];
                            return Card(
                              child: ListTile(
                                title: Text(item['direction_caption']),
                                subtitle: Text("Place: ${item['place']}, Mark: ${item['mark']}"),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(child: Text('Не подано ни одного направления...')),
          ],
        ),
      ),
    );
  }

    Future<void> logout(BuildContext context) async {
      mySharedPreferences.getDataIfNotExpired().then((cachedData) async{
      var json = jsonDecode(cachedData.toString());
      var cacheContent = ResponseWithToken.fromJson(json);

      var abiturient_id = cacheContent.abiturient_id;
      var token = cacheContent.token;

      var model = new UserLogoutModelRequest(abiturient_id: abiturient_id, token: token);
      var requestMap = model.toJson();

      var uris = GlobalEndpoints();

      var currentUri = uris.webUri;

      var requestString = '/logout';

      var currentPort = uris.currentWebPort;

      final url = Uri.parse(currentUri + currentPort + requestString);

      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode(requestMap);

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {

          MySharedPreferences mySharedPreferences = new MySharedPreferences();

          mySharedPreferences.clearData();

          Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthorizationPage()));

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
      });
    }
}