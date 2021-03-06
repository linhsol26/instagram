part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final User user;
  final List<Post> posts;
  final bool isCurrentUser;
  final bool isGridView;
  final bool isFollowing;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState(
      {@required this.isCurrentUser,
      @required this.posts,
      @required this.isGridView,
      @required this.isFollowing,
      @required this.status,
      @required this.failure,
      @required this.user});

  factory ProfileState.initial() => const ProfileState(
      isCurrentUser: false,
      isGridView: true,
      isFollowing: false,
      posts: [],
      status: ProfileStatus.initial,
      failure: Failure(),
      user: User.emptyUser);

  @override
  List<Object> get props =>
      [user, isCurrentUser, isGridView, status, isFollowing, failure, posts];

  ProfileState copyWith({
    User user,
    bool isCurrentUser,
    bool isGridView,
    bool isFollowing,
    List<Post> posts,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isGridView: isGridView ?? this.isGridView,
      isFollowing: isFollowing ?? this.isFollowing,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      posts: posts ?? this.posts,
    );
  }
}
