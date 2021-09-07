import 'package:instagram/models/models.dart';

abstract class BasePostRepository {
  Future<void> createPost({Post post});
  Future<void> createComment({Post post, Comment comment});
  Future<Set<String>> getLikedPostIds({String userId, List<Post> posts});
  void createLike({Post post, String userId});
  void deleteLike({String postId, String userId});
  Stream<List<Future<Post>>> getUserPosts({String userId});
  Stream<List<Future<Comment>>> getUserComments({String postId});
  Future<List<Post>> getUserFeed({String userId, String lastPostId});
}
