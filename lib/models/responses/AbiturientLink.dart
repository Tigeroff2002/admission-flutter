import 'dart:convert';

class AbiturientLink{

  final int abiturient_id;
  final String abiturient_name;
  final bool is_requested;
  final bool is_enrolled;
  final bool has_diplom_original;

  AbiturientLink({
    required this.abiturient_id,
    required this.abiturient_name,
    required this.is_requested,
    required this.is_enrolled,
    required this.has_diplom_original
  });

  factory AbiturientLink.fromJson(Map <String, dynamic> json) {
    return AbiturientLink(
      abiturient_id: json['abiturient_id'],
      abiturient_name: json['abiturient_name'],
      is_requested: json['is_requested'],
      is_enrolled: json['is_enrolled'],
      has_diplom_original: json['has_diplom_original']
    );
  }
}