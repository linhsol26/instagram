import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram/models/failure_model.dart';
import 'package:instagram/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: LoginStatus.initial,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
      status: LoginStatus.initial,
    ));
  }

  void loginWithCredentials() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.loginWithEmailAndPassword(
          email: state.email, password: state.password);
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (e) {
      emit(state.copyWith(
        failure: e,
        status: LoginStatus.error,
      ));
    }
  }
}
