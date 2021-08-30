import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/repositories/auth/auth_repository.dart';
import 'package:instagram/screens/login/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);
  static const String routeName = '/login';
  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Error'),
                  content: Text(state.failure.message),
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Instagram',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.0),
                            TextFormField(
                                decoration: InputDecoration(hintText: 'Email'),
                                onChanged: (value) => context
                                    .read<LoginCubit>()
                                    .emailChanged(value),
                                validator: (value) => !value.contains('@')
                                    ? 'Please enter a valid email.'
                                    : ''),
                            SizedBox(height: 16.0),
                            TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Password'),
                                obscureText: true,
                                onChanged: (value) => context
                                    .read<LoginCubit>()
                                    .passwordChanged(value),
                                validator: (value) => value.length < 6
                                    ? 'Password must be at least 6 characters.'
                                    : ''),
                            SizedBox(height: 28.0),
                            ElevatedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == LoginStatus.submitting),
                              style: ElevatedButton.styleFrom(
                                elevation: 1.0,
                                primary: Theme.of(context).primaryColor,
                                onPrimary: Colors.white,
                              ),
                              child: Text('Log In'),
                            ),
                            SizedBox(height: 12.0),
                            ElevatedButton(
                              onPressed: () =>
                                  print('No account button tapped.'),
                              style: ElevatedButton.styleFrom(
                                elevation: 1.0,
                                primary: Colors.grey[200],
                                onPrimary: Colors.black,
                              ),
                              child: Text('No Account? Sign Up'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<LoginCubit>().loginWithCredentials();
    }
  }
}
