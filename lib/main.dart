import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/blocs/auth/auth_bloc.dart';
import 'package:instagram/config/custom_router.dart';
import 'package:instagram/repositories/auth/auth_repository.dart';
import 'package:instagram/repositories/simple_bloc_observer.dart';
import 'package:instagram/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Instagram',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[50],
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              color: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              textTheme: const TextTheme(
                headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          initialRoute: SplashScreen.routeName,
          onGenerateRoute: CustomRouter.onGeneratedRoute,
        ),
      ),
    );
  }
}
