import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/cubits/cubits.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:instagram/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram/widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;

  ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  static const routeName = '/profile';

  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider<ProfileBloc>(
              create: (_) => ProfileBloc(
                  likedPostsCubit: context.read<LikedPostsCubit>(),
                  userRepository: context.read<UserRepository>(),
                  postRepository: context.read<PostRepository>(),
                  authBloc: context.read<AuthBloc>())
                ..add(ProfileLoadUser(userId: args.userId)),
              child: ProfileScreen(),
            ));
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            actions: [
              if (state.isCurrentUser)
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    context.read<LikedPostsCubit>().clearAllLikedPosts();
                  },
                  icon: Icon(Icons.exit_to_app),
                )
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      // case ProfileStatus.initial:
      //   return Center(
      //       child: CircularProgressIndicator(
      //     color: Colors.purple,
      //   ));
      case ProfileStatus.loading:
        return Center(
            child: CircularProgressIndicator(
          color: Colors.purple,
        ));
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
            return true;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
                      child: Row(
                        children: [
                          UserProfileImage(
                            profileImageUrl: state.user.profileImageUrl,
                            radius: 40.0,
                          ),
                          ProfileStats(
                            isCurrentUser: state.isCurrentUser,
                            isFollowing: state.isFollowing,
                            posts: state.posts.length,
                            followers: state.user.followers,
                            following: state.user.following,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: ProfileInfo(
                        username: state.user.username,
                        bio: state.user.bio,
                      ),
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.grid_on, size: 28.0)),
                    Tab(icon: Icon(Icons.list, size: 28.0)),
                  ],
                  indicatorWeight: 3.0,
                  onTap: (i) => context
                      .read<ProfileBloc>()
                      .add(ProfileToggleGridView(isGridView: i == 0)),
                ),
              ),
              state.isGridView
                  ? SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          return GestureDetector(
                            onTap: () {},
                            child: CachedNetworkImage(
                              imageUrl: post.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          final likedPostState =
                              context.watch<LikedPostsCubit>().state;
                          final isLiked =
                              likedPostState.likedPostIds.contains(post.id);
                          return PostView(
                            post: post,
                            isLike: isLiked,
                            onLike: () {
                              if (isLiked) {
                                context
                                    .read<LikedPostsCubit>()
                                    .unlikePost(post: post);
                              } else {
                                context
                                    .read<LikedPostsCubit>()
                                    .likePost(post: post);
                              }
                            },
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    ),
            ],
          ),
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
