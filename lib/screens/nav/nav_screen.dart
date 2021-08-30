import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({Key key}) : super(key: key);
  static const String routeName = '/nav';
  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => NavScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Nav Screen'),
    );
  }
}
