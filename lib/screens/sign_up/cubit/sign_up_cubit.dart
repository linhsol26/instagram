import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram/models/models.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;
  SignUpCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpState.initial());

  void usernameChanged(String value) {
    emit(state.copyWith(
      username: value,
      status: SignUpStatus.initial,
    ));
  }

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: SignUpStatus.initial,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
      status: SignUpStatus.initial,
    ));
  }

  void signUpWithCredentials() async {
    if (!state.isFormValid || state.status == SignUpStatus.submitting) return;
    emit(state.copyWith(status: SignUpStatus.submitting));
    try {
      await _authRepository.signUpWithEmailAndPassword(
          email: state.email,
          password: state.password,
          username: state.username);
      emit(state.copyWith(status: SignUpStatus.success));
    } on Failure catch (e) {
      emit(state.copyWith(
        failure: e,
        status: SignUpStatus.error,
      ));
    }
  }
}
