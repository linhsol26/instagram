import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/screens/login/login_screen.dart';
import 'package:instagram/screens/nav/nav_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);
  static const String routeName = '/splash';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print(state);
          if (state.status == AuthStatus.unauthenticated) {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushNamed(NavScreen.routeName);
          }
        },
        child: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
