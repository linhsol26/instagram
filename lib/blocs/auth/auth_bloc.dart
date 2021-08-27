import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<auth.User?>? _userSubcription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.unknown()) {
    _userSubcription = _authRepository.user
        .listen((user) => add(AuthUserChanged(user: user!)));
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthUserChanged) {
      yield AuthState.authenticated(user: event.user);
    } else if (event is AuthLogoutRequested) {
      await _authRepository.logOut();
    } else {
      yield AuthState.unauthenticated();
    }
  }

  @override
  Future<void> close() {
    _userSubcription?.cancel();
    return super.close();
  }
}
