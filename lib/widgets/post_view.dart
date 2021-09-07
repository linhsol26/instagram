import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/models.dart';
import 'package:instagram/screens/profile/profile_screen.dart';
import 'package:instagram/screens/screens.dart';
import 'package:instagram/widgets/widgets.dart';
import 'package:instagram/extensions/extensions.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLike;
  final VoidCallback onLike;
  final bool recentlyLike;

  const PostView(
      {Key key,
      @required this.post,
      @required this.isLike,
      @required this.onLike,
      this.recentlyLike = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                ProfileScreen.routeName,
                arguments: ProfileScreenArgs(userId: post.author.id)),
            child: Row(
              children: [
                UserProfileImage(
                    profileImageUrl: post.author.profileImageUrl, radius: 18.0),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    post.author.username,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: onLike,
          child: CachedNetworkImage(
              imageUrl: post.imageUrl,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 2.25,
              width: double.infinity),
        ),
        Row(
          children: [
            IconButton(
              icon: !isLike
                  ? Icon(Icons.favorite_outline)
                  : Icon(Icons.favorite, color: Colors.red),
              onPressed: onLike,
            ),
            IconButton(
              icon: Icon(Icons.comment_outlined),
              onPressed: () => Navigator.of(context).pushNamed(
                  CommentScreen.routeName,
                  arguments: CommentsStringArgs(post: post)),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${recentlyLike ? post.likes + 1 : post.likes} likes',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.0),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: post.author.username,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: ' '),
                TextSpan(text: post.caption),
              ])),
              SizedBox(height: 4.0),
              Text(post.date.timeAgo(),
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w500))
            ],
          ),
        ),
      ],
    );
  }
}
