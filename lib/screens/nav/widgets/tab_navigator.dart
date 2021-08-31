import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/config/custom_router.dart';
import 'package:instagram/enums/enums.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:instagram/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram/screens/screens.dart';

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
        return FeedScreen();
      case BottomNavItem.search:
        return SearchScreen();
      case BottomNavItem.create:
        return CreateScreen();
      case BottomNavItem.notifications:
        return NotificationsScreen();
      case BottomNavItem.profile:
        return BlocProvider(
          create: (_) => ProfileBloc(
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>())
            ..add(ProfileLoadUser(
                userId: context.read<AuthBloc>().state.user.uid)),
          child: ProfileScreen(),
        );
      default:
        return Scaffold();
    }
  }
}
