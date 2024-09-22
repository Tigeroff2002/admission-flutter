import 'dart:convert';

import 'package:admission_flutter/models/responses/AbiturientLink.dart';

class AllAbiturientsContent{

  final List<AbiturientLink> abiturients;

  AllAbiturientsContent({
    required this.abiturients
  });

  factory AllAbiturientsContent.fromJson(Map <String, dynamic> json) {
    return AllAbiturientsContent(
      abiturients: json['abiturients']
    );
  }
}