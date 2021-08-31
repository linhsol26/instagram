import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key key}) : super(key: key);
  static const routeName = '/feed';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Feed')),
    );
  }
}
