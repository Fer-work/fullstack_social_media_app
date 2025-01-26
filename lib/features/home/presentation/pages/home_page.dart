import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/home/presentation/components/my_drawer.dart';
import 'package:fullstack_social_media_app/features/post/presentation/components/post_tile.dart';
import 'package:fullstack_social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:fullstack_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:fullstack_social_media_app/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // grab post cubit
  late final postCubit = context.read<PostCubit>();

  // on startup
  @override
  void initState() {
    super.initState();

    // fetch posts
    fetchAllPosts();
  }

  // call fetch all posts
  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  // delete post
  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text("Home"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Drawer
      drawer: const MyDrawer(),

      // FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the create post page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadPostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

      // BODY
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // Loading state
          if (state is PostLoading || state is PostUploading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Loaded state
          else if (state is PostLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      "No posts found",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                final post = allPosts[index];
                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              },
            );
          }
          // Error state
          else if (state is PostError) {
            return Center(
              child: Text(
                state.message.isNotEmpty
                    ? state.message
                    : "An error occurred. Please try again.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
