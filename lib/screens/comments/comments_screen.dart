import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/models/models.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:instagram/screens/comments/bloc/comments_bloc.dart';
import 'package:instagram/screens/profile/profile_screen.dart';
import 'package:instagram/widgets/error_dialog.dart';
import 'package:instagram/widgets/widgets.dart';
import 'package:intl/intl.dart';

class CommentsStringArgs {
  final Post post;

  CommentsStringArgs({@required this.post});
}

class CommentScreen extends StatefulWidget {
  static const String routeName = '/comments';

  static Route route({@required CommentsStringArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CommentsBloc>(
        create: (_) => CommentsBloc(
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(CommentsFetchComments(post: args.post)),
        child: CommentScreen(),
      ),
    );
  }

  const CommentScreen({Key key}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentsStatus.error) {
          showDialog(
              context: context,
              builder: (context) =>
                  ErrorDialog(content: state.failure.message));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Comments')),
          body: ListView.builder(
              padding: EdgeInsets.only(bottom: 60.0),
              itemCount: state.comments.length,
              itemBuilder: (BuildContext context, int index) {
                final comment = state.comments[index];
                return ListTile(
                  leading: UserProfileImage(
                    radius: 22.0,
                    profileImageUrl: comment.author.profileImageUrl,
                  ),
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: comment.author.username,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: ' '),
                        TextSpan(text: comment.content),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMd().add_jm().format(comment.date),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                      ProfileScreen.routeName,
                      arguments: ProfileScreenArgs(userId: comment.author.id)),
                );
              }),
          bottomSheet: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == CommentsStatus.submitting)
                  LinearProgressIndicator(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentsController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Write yours comment...'),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          final content = _commentsController.text.trim();
                          if (content.isNotEmpty) {
                            context
                                .read<CommentsBloc>()
                                .add(CommentsPostComment(content: content));
                            _commentsController.clear();
                          }
                        },
                        icon: Icon(Icons.send)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }
}
