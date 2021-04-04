import 'dart:convert';

import 'package:flutter/foundation.dart';

class ApiResponse {
  final String id;
  final dynamic body;
  ApiResponse({
    @required this.id,
    @required this.body,
  });

  ApiResponse copyWith({
    String id,
    Map<String, dynamic> body,
  }) {
    return ApiResponse(
      id: id ?? this.id,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
    };
  }

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      id: map['id'],
      body: jsonDecode(map['body']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromJson(String source) =>
      ApiResponse.fromMap(json.decode(source));

  @override
  String toString() => 'ApiResponse(id: $id, body: $body)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiResponse &&
        other.id == id &&
        mapEquals(other.body, body);
  }

  @override
  int get hashCode => id.hashCode ^ body.hashCode;
}
