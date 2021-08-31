import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String username;
  final String bio;
  const ProfileInfo({Key key, @required this.username, @required this.bio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(username,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Text(bio,
            style: TextStyle(
              fontSize: 16.0,
            )),
        const Divider(thickness: 1.5),
      ],
    );
  }
}
