import 'dart:convert';

import 'package:admission_flutter/models/responses/AbiturientPlaceLink.dart';

class UserLKContent{

  final String first_name;
  final String second_name;
  final String email;
  final bool has_diplom_original;
  final bool is_enrolled;
  final List<AbiturientPlaceLink> directions_links;

  UserLKContent({
    required this.first_name,
    required this.second_name,
    required this.email,
    required this.has_diplom_original,
    required this.is_enrolled,
    required this.directions_links
  });

  factory UserLKContent.fromJson(Map <String, dynamic> json) {
    return UserLKContent(
      first_name: json['first_name'],
      second_name: json['second_name'],
      email: json['email'],
      has_diplom_original: json['has_diplom_original'],
      is_enrolled: json['is_enrolled'],
      directions_links: json['directions_links']
    );
  }
}