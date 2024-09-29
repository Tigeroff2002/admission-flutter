import 'dart:convert';
import 'package:admission_flutter/LKWidget.dart';
import 'package:admission_flutter/SingleDirectionPage.dart';
import 'package:admission_flutter/models/requests/GetAllDirectionsRequest.dart';
import 'package:admission_flutter/models/responses/ResponseWithToken.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DirectionsPage extends StatefulWidget {

  @override
  DirectionsPageState createState() => DirectionsPageState();
}

class DirectionsPageState extends State<DirectionsPage> {

  List<dynamic> directions = [];
  bool isLoading = true;
  String? error;

  MySharedPreferences mySharedPreferences = new MySharedPreferences();

  @override
  void initState() {

    mySharedPreferences.getDataIfNotExpired().then((value) {
      if (value == null) {
        Future(() {
          Navigator.of(context).pushNamed('/');
        });
      }     
    });

    super.initState();

    fetchDirections();
  }

  Future<void> fetchDirections() async {
    mySharedPreferences.getDataIfNotExpired().then((cachedData) async{

    var json = jsonDecode(cachedData.toString());
    var cacheContent = ResponseWithToken.fromJson(json);

    var abiturient_id = cacheContent.abiturient_id;
    var token = cacheContent.token;

    var model = new GetAllDirectionsRequest(abiturient_id: abiturient_id, token: token);
    var requestMap = model.toJson();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/directions'),
        body: jsonEncode(requestMap),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == true) {
          setState(() {
            directions = data['content']['directions'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            error = data['failure_message'] ?? 'Failed to load directions';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        error = 'Error with API request';
        isLoading = false;
      });
      print('Error with API request: $e');
    }
    });
  }

  void handleRowClick(int direction_id) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SingleDirectionPage(direction_id: direction_id)));
  }

  void handleBackToLKClick() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LK()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(height: 0.0),
        centerTitle: true,
        automaticallyImplyLeading: false
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Список направлений',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : error != null
                          ? Text(error!)
                          : directions.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: directions.length,
                                    itemBuilder: (context, index) {
                                      final direction = directions[index];
                                      return GestureDetector(
                                        onTap: () => handleRowClick(direction['direction_id']),
                                        child: Card(
                                          margin: EdgeInsets.symmetric(vertical: 8.0),
                                          child: ListTile(
                                            title: Text(
                                              'ID: ${direction['direction_id']}',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(direction['direction_caption']),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Text('Нет данных для отображения.'),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: handleBackToLKClick,
                                child: Text('Вернуться в ЛК'),
                              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
