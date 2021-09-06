import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/cubits/likes/liked_posts_cubit.dart';
import 'package:instagram/models/models.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  StreamSubscription<List<Future<Post>>> _postsSubscription;

  ProfileBloc(
      {@required UserRepository userRepository,
      @required PostRepository postRepository,
      @required LikedPostsCubit likedPostsCubit,
      @required AuthBloc authBloc})
      : _userRepository = userRepository,
        _authBloc = authBloc,
        _postRepository = postRepository,
        _likedPostsCubit = likedPostsCubit,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    } else if (event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewToState(event);
    } else if (event is ProfileUpdatePosts) {
      yield* _mapProfileUpdatePostsToState(event);
    } else if (event is ProfileFollowUser) {
      yield* _mapProfileFollowUserToState(event);
    } else if (event is ProfileUnfollowUser) {
      yield* _mapProfileUnfollowUserToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == event.userId;

      final isFollow = await _userRepository.isFollowing(
          userId: _authBloc.state.user.uid, otherUserId: event.userId);

      _postsSubscription?.cancel();
      _postsSubscription = _postRepository
          .getUserPosts(userId: event.userId)
          .listen((posts) async {
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts: allPosts));
      });

      yield state.copyWith(
          user: user,
          isCurrentUser: isCurrentUser,
          status: ProfileStatus.loaded,
          isFollowing: isFollow);
    } catch (e) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: e.toString()),
      );
    }
  }

  Stream<ProfileState> _mapProfileToggleGridViewToState(
      ProfileToggleGridView event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  @override
  Future<void> close() {
    _postsSubscription.cancel();
    return super.close();
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(
      ProfileUpdatePosts event) async* {
    yield state.copyWith(posts: event.posts);
    final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user.uid, posts: event.posts);

    _likedPostsCubit.updateLikedPost(postIds: likedPostIds);
  }

  Stream<ProfileState> _mapProfileFollowUserToState(
      ProfileFollowUser event) async* {
    try {
      _userRepository.followUser(
          userId: _authBloc.state.user.uid, followUserId: state.user.id);
      final updatedUser =
          state.user.copyWith(followers: state.user.followers + 1);
      yield state.copyWith(user: updatedUser, isFollowing: true);
    } catch (e) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: e.toString()),
      );
    }
  }

  Stream<ProfileState> _mapProfileUnfollowUserToState(
      ProfileUnfollowUser event) async* {
    try {
      _userRepository.unfollowUser(
          userId: _authBloc.state.user.uid, unfollowUserId: state.user.id);
      final updatedUser =
          state.user.copyWith(followers: state.user.followers - 1);
      yield state.copyWith(user: updatedUser, isFollowing: false);
    } catch (e) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: e.toString()),
      );
    }
  }
}
