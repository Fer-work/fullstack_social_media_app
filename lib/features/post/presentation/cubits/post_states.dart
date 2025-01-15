/*

  Post states

*/

import 'package:fullstack_social_media_app/features/post/domain/entities/post.dart';

abstract class PostState {}

// initial state
class PostInitial extends PostState {}

// loading state
class PostLoading extends PostState {}

// uploading state
class PostUploading extends PostState {}

// error
class PostError extends PostState {
  final String message;
  PostError({required this.message});
}

// success
class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded({required this.posts});
}
