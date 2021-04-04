import 'package:flutter/material.dart';

import 'package:multi_channel/multi_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ApiClient apiClient = ApiClient("https://jsonplaceholder.typicode.com");
  List<String> responses = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView.builder(
          itemCount: responses.length,
          itemBuilder: (context, index) => Card(
            child: ExpansionTile(
              title: Text("Request $index"),
              children: [Text(responses[index])],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final futures = <Future<ApiResponse>>[];
            List.generate(1, (index) async {
              futures.add(apiClient.post("/posts"));
            });
            final responseFutures = await Future.wait(futures);
            responses = responseFutures.map((e) => e.body.toString()).toList();
            setState(() {});
          },
        ),
      ),
    );
  }
}
