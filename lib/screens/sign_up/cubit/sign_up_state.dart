part of 'sign_up_cubit.dart';

enum SignUpStatus { initial, submitting, success, error }

class SignUpState extends Equatable {
  final String username;
  final String email;
  final String password;
  final SignUpStatus status;
  final Failure failure;
  const SignUpState(
      {@required this.username,
      @required this.email,
      @required this.password,
      @required this.status,
      @required this.failure});

  @override
  List<Object> get props => [username, email, password, status, failure];

  @override
  bool get stringify => true;

  factory SignUpState.initial() {
    return SignUpState(
      username: '',
      email: '',
      password: '',
      status: SignUpStatus.initial,
      failure: Failure(),
    );
  }

  bool get isFormValid =>
      username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;

  SignUpState copyWith({
    String username,
    String email,
    String password,
    SignUpStatus status,
    Failure failure,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
