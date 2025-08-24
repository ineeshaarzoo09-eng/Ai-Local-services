import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Your booking has been confirmed"),
            subtitle: Text("2 min ago"),
          ),
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text("Payment successful"),
            subtitle: Text("10 min ago"),
          ),
        ],
      ),
    );
  }
}
