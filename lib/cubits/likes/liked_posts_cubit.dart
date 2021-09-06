import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/models/models.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'liked_posts_state.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  PostRepository _postRepository;
  AuthBloc _authBloc;

  LikedPostsCubit(PostRepository postRepository, AuthBloc authBloc)
      : _postRepository = postRepository,
        _authBloc = authBloc,
        super(LikedPostsState.initial());

  void updateLikedPost({@required Set<String> postIds}) {
    emit(state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds)));
  }

  void likePost({@required Post post}) {
    _postRepository.createLike(post: post, userId: _authBloc.state.user.uid);
    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id),
      recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
        ..add(post.id),
    ));
  }

  void unlikePost({@required Post post}) {
    _postRepository.deleteLike(
        postId: post.id, userId: _authBloc.state.user.uid);
    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..remove(post.id),
      recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
        ..remove(post.id),
    ));
  }

  void clearAllLikedPosts() {
    emit(LikedPostsState.initial());
  }
}
