import 'dart:convert';

class RequestWithToken {
    final int abiturient_id;
    final String token;

    RequestWithToken({required this.abiturient_id, required this.token});

    Map<String, dynamic> toJson() {
        return {
            'abiturient_id': abiturient_id,
            'token': token
        };
    }
}