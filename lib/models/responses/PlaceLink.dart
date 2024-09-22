import 'dart:convert';

class PlaceLink{

  final int place;
  final int abiturient_id;
  final String abiturient_name;
  final int mark;
  final String admission_status;
  final int prioritet_number;
  final bool has_diplom_original;

  PlaceLink({
    required this.place,
    required this.abiturient_id,
    required this.abiturient_name,
    required this.mark,
    required this.admission_status,
    required this.prioritet_number,
    required this.has_diplom_original
  });

  factory PlaceLink.fromJson(Map <String, dynamic> json) {
    return PlaceLink(
      place: json['place'],
      abiturient_id: json['abiturient_id'],
      abiturient_name: json['abiturient_name'],
      mark: json['mark'],
      admission_status: json['admission_status'],
      prioritet_number: json['prioritet_number'],
      has_diplom_original: json['has_diplom_original']
    );
  }
}