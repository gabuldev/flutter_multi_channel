import 'dart:async';
import 'api_response.dart';

String get uuid => DateTime.now().toIso8601String();

abstract class RequestBase {
  String get id;
  Completer<ApiResponse> get completer;
  RequestBase head(Map<String, dynamic> data);
  RequestBase body(Map<String, dynamic> data);
  RequestBase post(String path);
  RequestBase get(String path);
  RequestBase put(String path);
  RequestBase delete(String path);
  Map<String, dynamic> toJson();
}

class ApiResquest implements RequestBase {
  String _id;
  String _method;
  String _path;
  Completer<ApiResponse> _completer = Completer<ApiResponse>();
  // ignore: unused_field
  Map<String, dynamic> _head;
  // ignore: unused_field
  Map<String, dynamic> _body;
  ApiResquest() {
    _id = uuid;
    print("UUID: $_id");
  }
  @override
  body(Map<String, dynamic> data) {
    _body = data;
    return this;
  }

  @override
  head(Map<String, dynamic> data) {
    _head = data;
    return this;
  }

  @override
  String get id => _id;

  @override
  Completer<ApiResponse> get completer => _completer;

  @override
  Map<String, dynamic> toJson() => {
        "id": _id,
        "body": _body,
        "head": _head,
        "method": _method,
        "path": _path,
      };

  @override
  RequestBase delete(String path) {
    _method = "DELETE";
    _path = path;
    return this;
  }

  @override
  RequestBase get(String path) {
    _method = "GET";
    _path = path;
    return this;
  }

  @override
  RequestBase post(String path) {
    _method = "POST";
    _path = path;
    return this;
  }

  @override
  RequestBase put(String path) {
    _method = "UPDATE";
    _path = path;
    return this;
  }
}
