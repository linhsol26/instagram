import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/enums/enums.dart';
import 'package:instagram/models/notification_model.dart';
import 'package:instagram/screens/screens.dart';
import 'package:instagram/widgets/widgets.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final Notif notification;
  const NotificationTile({Key key, @required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserProfileImage(
        radius: 18.0,
        profileImageUrl: notification.fromUser.profileImageUrl,
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: notification.fromUser.username,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: ' '),
            TextSpan(text: _getText(notification)),
          ],
        ),
      ),
      subtitle: Text(
        DateFormat.yMd().add_jm().format(notification.date),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: _getTrailing(context, notification),
      onTap: () => Navigator.of(context).pushNamed(ProfileScreen.routeName,
          arguments: ProfileScreenArgs(userId: notification.fromUser.id)),
    );
  }

  String _getText(Notif notification) {
    switch (notification.type) {
      case NotificationType.comment:
        return 'commented your post';
      case NotificationType.like:
        return 'liked your post';
      case NotificationType.follow:
        return 'followed you';
      default:
        return '';
    }
  }

  Widget _getTrailing(BuildContext context, Notif notification) {
    if (notification.type == NotificationType.comment ||
        notification.type == NotificationType.like) {
      return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(CommentScreen.routeName,
              arguments: CommentsStringArgs(post: notification.post)),
          child: CachedNetworkImage(
            imageUrl: notification.post.imageUrl,
            height: 60.0,
            width: 60.0,
            fit: BoxFit.cover,
          ));
    } else if (notification.type == NotificationType.follow) {
      return SizedBox(
        height: 60.0,
        width: 60.0,
        child: Icon(Icons.person_add),
      );
    }
    return SizedBox.shrink();
  }
}
