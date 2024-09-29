import 'dart:convert';
import 'package:admission_flutter/LKWidget.dart';
import 'package:admission_flutter/models/requests/UserLKModelRequest.dart';
import 'package:admission_flutter/models/responses/AdminCheckResponse.dart';
import 'package:admission_flutter/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminLK extends StatefulWidget {
  @override
  AdminLKState createState() => AdminLKState();
}

class AdminLKState extends State<AdminLK> {

  String profilePictureUrl = 'https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg';
  List<dynamic> abiturients = [];
  List<dynamic> directionsInformations = [];
  String? selectedAbiturientId;
  bool hasDiplomOriginal = false;
  List<Map<String, String>> directions = List.generate(3, (index) => {'directionId': '', 'prioritetNumber': ''});
  bool isAdmin = false;
  bool isLoading = true;

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
      }    
    });

    super.initState();

    fetchAbiturients();
  }

  Future<void> fetchAbiturients() async {
    mySharedPreferences.getDataIfNotExpired().then((cachedData) async{

    var json = jsonDecode(cachedData.toString());
    var cacheContent = AdminCheckResponse.fromJson(json);

    var abiturient_id = cacheContent.abiturient_id;
    var token = cacheContent.token;

    var model = new UserLKModelRequest(abiturient_id: abiturient_id, token: token);
    var requestMap = model.toJson();

    try {
      var response = await http.post(
        Uri.parse('http://localhost:8000/abiturients/all'),
        body: jsonEncode(requestMap),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body)['content'];
        setState(() {
          abiturients = content['abiturients'] ?? [];
        });
      } else {
        Navigator.of(context).pushReplacementNamed('/');
      }

      response = await http.post(
        Uri.parse('http://localhost:8000/directions'),
        body: jsonEncode(requestMap),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var directionsData = jsonDecode(response.body)['content']['directions'] ?? [];
        setState(() {
          directionsInformations = directionsData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error with API request: $error');
      setState(() {
        isLoading = false;
      });
    }
    });
  }

  void handleRowClick(dynamic abiturient) {
    setState(() {
      selectedAbiturientId = selectedAbiturientId == abiturient['abiturient_id'] ? null : abiturient['abiturient_id'];
      hasDiplomOriginal = false;
      directions = List.generate(3, (index) => {'directionId': '', 'prioritetNumber': ''});
    });
  }

    void handleBackToLKClick() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LK()));
  }

  void handleSubmit() async {

    mySharedPreferences.getDataIfNotExpired().then((cachedData) async{

    var json = jsonDecode(cachedData.toString());
    var cacheContent = AdminCheckResponse.fromJson(json);

    var abiturient_id = cacheContent.abiturient_id;
    var token = cacheContent.token;

    var requestData = {
      'abiturient_id': abiturient_id,
      'token': token,
      'content': {
        'target_abiturient_id': selectedAbiturientId,
        'has_diplom_original': hasDiplomOriginal,
        'directions_links': directions.asMap().entries.map((entry) {
          int index = entry.key;
          var direction = entry.value;
          return {
            'direction_id': direction['directionId'],
            'prioritet_number': index + 1,
            'mark': 0,
          };
        }).toList(),
      },
    };

    try {
      var response = await http.post(
        Uri.parse('http://localhost:8000/abiturients/addInfo'),
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 200) {
        fetchAbiturients();
      } else {
        print('Failed to add information');
      }
    } catch (error) {
      print('Error submitting data: $error');
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profilePictureUrl),
                          radius: 75,
                        ),
                        SizedBox(height: 16),
                        isAdmin
                            ? abiturients.isNotEmpty
                                ? Column(
                                    children: [
                                      Text(
                                        "Список абитуриентов",
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                      DataTable(
                                        columns: [
                                          DataColumn(label: Text("Имя абитуриента")),
                                          DataColumn(label: Text("Подавал доки?")),
                                          DataColumn(label: Text("Уже зачислен?")),
                                        ],
                                        rows: abiturients.map((item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(item['abiturient_name'])),
                                              DataCell(Text(item['is_requested'] ? 'Да' : 'Нет')),
                                              DataCell(Text(item['is_enrolled'] ? 'Да' : 'Нет')),
                                            ],
                                            selected: selectedAbiturientId == item['abiturient_id'],
                                            onSelectChanged: (isSelected) {
                                              handleRowClick(item);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      if (selectedAbiturientId != null)
                                        Column(
                                          children: [
                                            CheckboxListTile(
                                              title: Text("Есть оригинал диплома?"),
                                              value: hasDiplomOriginal,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  hasDiplomOriginal = value ?? false;
                                                });
                                              },
                                            ),
                                            ...List.generate(directions.length, (index) {
                                              var matchingDirection = directionsInformations.firstWhere(
                                                  (info) => info['direction_id'] == directions[index]['directionId'],
                                                  orElse: () => null);

                                              return Column(
                                                children: [
                                                  Text(matchingDirection != null
                                                      ? 'Направление ${index + 1}: ${matchingDirection['direction_caption']}'
                                                      : 'Направление ${index + 1}: Нет данных'),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                      labelText: 'ID направления',
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        directions[index]['directionId'] = value;
                                                      });
                                                    },
                                                  ),
                                                  Text("Номер приоритета: ${index + 1}"),
                                                ],
                                              );
                                            }),
                                            ElevatedButton(
                                              onPressed: handleSubmit,
                                              child: Text("Сохранить"),
                                            ),
                                          ],
                                        ),
                                    ],
                                  )
                                : Text("Пока нет данных для отображения.")
                            : Container(),
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
