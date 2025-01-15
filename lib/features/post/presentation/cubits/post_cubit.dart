import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/post/domain/entities/post.dart';
import 'package:fullstack_social_media_app/features/post/domain/repos/post_repo.dart';
import 'package:fullstack_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:fullstack_social_media_app/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit(
    this.postRepo,
    this.storageRepo,
  ) : super(PostInitial());

  // create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      // handle image upload for mobile platforms using file path
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      // handle image upload for web
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      // give image url to post
      final newPost = post.copywith(imageUrl: imageUrl);

      // create post in the backend
      postRepo.createPost(newPost);

      // re-fetch all postst
      fetchAllPosts();
    } catch (e) {
      emit(PostError(message: "Error creating post: $e"));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: "Error fetching posts: $e"));
    }
  }

  // delete a post
  Future<void> deletePost(String postId) async {
    try {
      emit(PostLoading());
      await postRepo.deletePost(postId);
      fetchAllPosts(); // might need to remove this later since this is from copilot and not the tutorial
    } catch (e) {
      emit(PostError(message: "Error deleting post: $e"));
    }
  }
}
