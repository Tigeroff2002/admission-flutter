import 'dart:convert';

class Response{

  final Object? content;
  final String? failure_message;
  final bool result;

  Response({
    this.content,
    this.failure_message,
    required this.result
  });

  factory Response.fromJson(Map <String, dynamic> json) {
    return Response(
        content: json['content'],
        failure_message: json['failure_message'],
        result: json['result']
    );
  }
}