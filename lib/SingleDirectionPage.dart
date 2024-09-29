import 'dart:convert';
import 'dart:io';
import 'package:admission_flutter/DirectionsPage.dart';
import 'package:admission_flutter/models/requests/GetDirectionInfoRequest.dart';
import 'package:admission_flutter/models/responses/AdminCheckResponse.dart';
import 'package:admission_flutter/models/responses/ResponseWithToken.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:async';

class SingleDirectionPage extends StatefulWidget {
  final int direction_id;
  SingleDirectionPage({required this.direction_id});

  @override
  SingleDirectionPageState createState() => 
    SingleDirectionPageState(direction_id: direction_id);
}

class SingleDirectionPageState extends State<SingleDirectionPage> {

  int direction_id = 0;
  String directionCaption = '';
  int directionPlacesNumber = 0;
  int directionMinBall = 0;
  List<dynamic> places = [];
  bool isLoading = true;
  String? error;
  bool showModal = false;
  bool isAdmin = false;
  int abiturient_id = 0;

  SingleDirectionPageState({required this.direction_id});

  MySharedPreferences mySharedPreferences = new MySharedPreferences();

  @override
  void initState() {

     mySharedPreferences.getDataIfNotExpired().then((value) {
      if (value == null) {
        Future(() {
          Navigator.of(context).pushNamed('/');
        });
      }  
      else{
        var json = jsonDecode(value.toString());
        var cacheContent = AdminCheckResponse.fromJson(json);
        isAdmin = cacheContent.is_admin; 
        abiturient_id = cacheContent.abiturient_id;    
      }    
    });

    super.initState();

    getDirectionData();
  }

  Future<void> getDirectionData() async {
    mySharedPreferences.getDataIfNotExpired().then((cachedData) async{

    var json = jsonDecode(cachedData.toString());
    var cacheContent = ResponseWithToken.fromJson(json);

    var abiturient_id = cacheContent.abiturient_id;
    var token = cacheContent.token;

    var model = new GetDirectionInfoRequest(abiturient_id: abiturient_id, token: token, direction_id: direction_id);
    var requestMap = model.toJson();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/direction'),
        body: jsonEncode(requestMap),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == true) {
          setState(() {
            directionCaption = data['content']['direction_caption'];
            directionPlacesNumber = data['content']['budget_places_number'];
            directionMinBall = data['content']['min_ball'];
            places = data['content']['places'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            error = data['failure_message'] ?? 'Failed to load places';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        error = 'Error with API request';
        isLoading = false;
      });
    }
    });
  }

  void toggleModal() {
    setState(() {
      showModal = !showModal;
    });
  }

  Future<void> handleFileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      print("File selected: ${file.path}");
    }
  }

  void handleDownloadEmptyCSV() {
  }

  void redirectToDirectionsPage() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DirectionsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Настройки:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Бюджетных мест: $directionPlacesNumber'),
                  SizedBox(height: 5),
                  Text('Проходной балл: $directionMinBall'),
                  SizedBox(height: 20),
                  isAdmin 
                  ? ElevatedButton(
                      onPressed: toggleModal,
                      child: Text('Управление баллами'),
                    ) 
                  : SizedBox(height: 0.0),
                  SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : error != null
                          ? Text(error!)
                          : places.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: places.length,
                                    itemBuilder: (context, index) {
                                      var place = places[index];
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                              'Место: ${place['place']} - Абитуриент: ${place['abiturient_name']}'),
                                          subtitle: Text('Оценка: ${place['mark']}'),
                                          tileColor: place['abiturient_id'] == abiturient_id ? Colors.pink : null
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Text('Нет данных для отображения.'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: redirectToDirectionsPage,
                    child: Text('Вернуться ко всему списку'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: showModal
          ? FloatingActionButton(
              onPressed: toggleModal,
              child: Icon(Icons.close),
            )
          : null,
    );
  }
}