import 'dart:async';

import 'package:streams_channel/streams_channel.dart';

import 'api_request.dart';
import 'api_response.dart';

class ApiClient {
  final String baseURL;
  final _channel = StreamsChannel("multi_channel");
  ApiClient(this.baseURL);

  Future<ApiResponse> post(String path,
      {Map<String, dynamic> body, Map<String, dynamic> head}) async {
    final _request = ApiResquest().post(baseURL + path).body(body).head(head);
    _channel.receiveBroadcastStream(_request.toJson()).listen((data) {
      _request.completer
          .complete(ApiResponse.fromMap(Map<String, dynamic>.from(data)));
    });

    return await _request.completer.future;
  }
}
