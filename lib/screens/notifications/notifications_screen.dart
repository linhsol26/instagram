import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key key}) : super(key: key);

  static const routeName = '/notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Notifications')),
    );
  }
}
