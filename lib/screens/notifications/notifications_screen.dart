import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/repositories/notification/bloc/notifications_bloc.dart';
import 'package:instagram/screens/notifications/widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key key}) : super(key: key);

  static const routeName = '/notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          switch (state.status) {
            case NotificationStatus.error:
              return Center(
                child: Text(state.failure.message),
              );
            case NotificationStatus.loaded:
              return ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    final notification = state.notifications[index];
                    return NotificationTile(notification: notification);
                  });
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
