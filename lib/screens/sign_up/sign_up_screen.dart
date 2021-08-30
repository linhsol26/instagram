import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/repositories/auth/auth_repository.dart';
import 'package:instagram/screens/sign_up/cubit/sign_up_cubit.dart';
import 'package:instagram/widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key key}) : super(key: key);
  static const String routeName = '/signup';
  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider(
        create: (_) =>
            SignUpCubit(authRepository: context.read<AuthRepository>()),
        child: SignUpScreen(),
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
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.status == SignUpStatus.error) {
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
              backgroundColor: Colors.blueGrey,
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
                                decoration:
                                    InputDecoration(hintText: 'Username'),
                                onChanged: (value) => context
                                    .read<SignUpCubit>()
                                    .usernameChanged(value),
                                validator: (value) => value.trim().isEmpty
                                    ? 'Please enter username.'
                                    : null),
                            SizedBox(height: 16.0),
                            TextFormField(
                                decoration: InputDecoration(hintText: 'Email'),
                                onChanged: (value) => context
                                    .read<SignUpCubit>()
                                    .emailChanged(value),
                                validator: (value) => !value.contains('@')
                                    ? 'Please enter a valid email.'
                                    : null),
                            SizedBox(height: 16.0),
                            TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Password'),
                                obscureText: true,
                                onChanged: (value) => context
                                    .read<SignUpCubit>()
                                    .passwordChanged(value),
                                validator: (value) => value.length < 6
                                    ? 'Password must be at least 6 characters.'
                                    : null),
                            SizedBox(height: 28.0),
                            ElevatedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == SignUpStatus.submitting),
                              style: ElevatedButton.styleFrom(
                                elevation: 1.0,
                                primary: Theme.of(context).primaryColor,
                                onPrimary: Colors.white,
                              ),
                              child: Text('Sign Up'),
                            ),
                            SizedBox(height: 12.0),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                elevation: 1.0,
                                primary: Colors.grey[200],
                                onPrimary: Colors.black,
                              ),
                              child: Text('Back to Login'),
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
      context.read<SignUpCubit>().signUpWithCredentials();
    }
  }
}
