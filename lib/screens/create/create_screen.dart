import 'package:flutter/material.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({Key key}) : super(key: key);
  static const routeName = '/create';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Create')),
    );
  }
}
