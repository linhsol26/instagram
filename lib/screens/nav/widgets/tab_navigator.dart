import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/config/custom_router.dart';
import 'package:instagram/cubits/likes/liked_posts_cubit.dart';
import 'package:instagram/enums/enums.dart';
import 'package:instagram/repositories/notification/bloc/notifications_bloc.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:instagram/screens/create/cubit/create_post_cubit.dart';
import 'package:instagram/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram/screens/screens.dart';
import 'package:instagram/screens/search/cubit/search_cubit.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;
  const TabNavigator(
      {Key key, @required this.navigatorKey, @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _routeBuilders = routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initalRoute) {
        return [
          MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => _routeBuilders[initalRoute](context))
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return BlocProvider<FeedBloc>(
          create: (context) => FeedBloc(
              likedPostsCubit: context.read<LikedPostsCubit>(),
              postRepository: context.read<PostRepository>(),
              authBloc: context.read<AuthBloc>())
            ..add(FeedFetchPosts()),
          child: FeedScreen(),
        );
      case BottomNavItem.search:
        return BlocProvider<SearchCubit>(
          create: (context) =>
              SearchCubit(userRepository: context.read<UserRepository>()),
          child: SearchScreen(),
        );
      case BottomNavItem.create:
        return BlocProvider<CreatePostCubit>(
          create: (context) => CreatePostCubit(
            postRepository: context.read<PostRepository>(),
            storageRepository: context.read<StorageRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: CreateScreen(),
        );
      case BottomNavItem.notifications:
        return BlocProvider<NotificationsBloc>(
          create: (context) => NotificationsBloc(
            notificationRepository: context.read<NotificationRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: NotificationsScreen(),
        );
      case BottomNavItem.profile:
        return BlocProvider(
          create: (_) => ProfileBloc(
            likedPostsCubit: context.read<LikedPostsCubit>(),
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
            postRepository: context.read<PostRepository>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user.uid)),
          child: ProfileScreen(),
        );
      default:
        return Scaffold();
    }
  }
}
