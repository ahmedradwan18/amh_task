import 'package:amh_task/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(
          channel: new IOWebSocketChannel.connect("ws://echo.websocket.org"),
        ),
      ),
    );
  }
}
