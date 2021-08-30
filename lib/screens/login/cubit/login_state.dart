part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final Failure failure;
  const LoginState(
      {@required this.email,
      @required this.password,
      @required this.status,
      @required this.failure});

  @override
  List<Object> get props => [email, password, status, failure];

  @override
  bool get stringify => true;

  factory LoginState.initial() {
    return LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
      failure: Failure(),
    );
  }

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String email,
    String password,
    LoginStatus status,
    Failure failure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
