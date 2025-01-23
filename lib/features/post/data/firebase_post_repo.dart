import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullstack_social_media_app/features/post/domain/entities/comment.dart';
import 'package:fullstack_social_media_app/features/post/domain/entities/post.dart';
import 'package:fullstack_social_media_app/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Store the posts in a collection called 'posts'
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');
  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating posts: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all posts with most recent posts at the top
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      // convert each firestore document from a json to a list of posts
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchUserPostsByUserId(String userId) async {
    try {
      // fetch posts snapshot with this uid
      final postsSnpashot =
          await postsCollection.where('userId', isEqualTo: userId).get();

      // map firestone document to a list of posts
      final List<Post> userPosts = postsSnpashot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      // get the post document from firestore
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // check if user has already liked this posts
        final hasLiked = post.likes.contains(userId);

        // update the like list
        if (hasLiked) {
          post.likes.remove(userId); // unlike
        } else {
          post.likes.add(userId); // like
        }

        // update the post document with the new like list
        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception("Post does not exist");
      }
    } catch (e) {
      throw Exception("Error toggling like: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      // Get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // Convert JSON object -> Post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Add the new comment
        post.comments.add(comment);

        // Update the post document in Firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // Get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // Convert JSON object -> Post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // Remove the comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        // Update the post document in Firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error deleting comment: $e");
    }
  }
}
