import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  final WebSocketChannel channel;
  HomePage({@required this.channel});

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin fltrLocalNotification;
  TextEditingController editingController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    // Intilializing The Plugin
    var androidInitilize = AndroidInitializationSettings('logo');
    var iOSinitilize = IOSInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    fltrLocalNotification = FlutterLocalNotificationsPlugin();
    fltrLocalNotification.initialize(initilizationsSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AMH Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                decoration: InputDecoration(labelText: "Send any message"),
                controller: editingController,
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData && isLoading == true) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  isLoading = false;

// here we listen from the server and push a notification with the received message
                  if (snapshot.data != null && snapshot.hasData) {
                    _showNotification(snapshot.data);
                  }

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                  );
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: _sendMyMessage,
      ),
    );
  }

  Future _showNotification(String text) async {
    var androidDetails = AndroidNotificationDetails(
        "Channel ID", "AMH Technology", "This is my task",
        importance: Importance.max);
    var iSODetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iSODetails);

    await fltrLocalNotification
        .show(0, "Task", text, generalNotificationDetails, payload: "Task");
    editingController.text = "";
  }

  void _sendMyMessage() {
    if (editingController.text != '') {
      widget.channel.sink.add(editingController.text);
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
