import 'dart:html';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Browser Action Detection'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Listen for messages from JavaScript
    window.onMessage.listen((event) {
      // Handle messages received from JavaScript
      if (event.data == 'beforeunload') {
        // Call Dart function for beforeunload event
        handleBeforeUnload();
      } else if (event.data == 'refresh') {
        // Call Dart function for refresh event
        handleRefresh();
      } else if (event.data == 'close') {
        // Call Dart function for close event
        handleClose();
      }
    });
  }

  void handleBeforeUnload() {
    // Implement your logic for beforeunload event
    print('Beforeunload event detected');
  }

  void handleRefresh() {
    // Implement your logic for refresh event
    print('Refresh event detected');
  }

  void handleClose() {
    // Implement your logic for close event
    print('Close event detected');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Press browser refresh or close button',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}