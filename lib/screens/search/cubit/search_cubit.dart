import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram/models/models.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;
  SearchCubit({UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchState.initial());

  void searchUser({String query}) async {
    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final users = await _userRepository.searchUsers(query: query);
      emit(state.copyWith(users: users, status: SearchStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          status: SearchStatus.error, failure: Failure(message: e.toString())));
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchStatus.initial));
  }
}
