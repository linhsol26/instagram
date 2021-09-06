import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/cubits/likes/liked_posts_cubit.dart';
import 'package:instagram/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram/widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key key}) : super(key: key);
  static const routeName = '/feed';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FeedBloc>().state.status != FeedStatus.paginating) {
          context.read<FeedBloc>().add(FeedPaginatePosts());
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        } else if (state.status == FeedStatus.paginating) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fetching more posts..'),
              backgroundColor: Theme.of(context).primaryColor,
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Instagram'),
              actions: [
                if (state.posts.isEmpty && state.status == FeedStatus.loaded)
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () =>
                        context.read<FeedBloc>().add(FeedFetchPosts()),
                  ),
              ],
            ),
            body: _buildBody(state));
      },
    );
  }

  Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPosts());
            return true;
          },
          child: ListView.builder(
              controller: _scrollController,
              itemCount: state.posts.length,
              itemBuilder: (BuildContext context, int index) {
                final post = state.posts[index];
                final likedPostState = context.watch<LikedPostsCubit>().state;
                final isLiked = likedPostState.likedPostIds.contains(post.id);
                final recentlyLiked =
                    likedPostState.recentlyLikedPostIds.contains(post.id);
                return PostView(
                    post: post,
                    isLike: isLiked,
                    recentlyLike: recentlyLiked,
                    onLike: () {
                      if (isLiked) {
                        context.read<LikedPostsCubit>().unlikePost(post: post);
                      } else {
                        context.read<LikedPostsCubit>().likePost(post: post);
                      }
                    });
              }),
        );
    }
  }
}
