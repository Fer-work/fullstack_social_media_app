import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:fullstack_social_media_app/features/post/domain/entities/post.dart';
import 'package:fullstack_social_media_app/features/post/domain/entities/comment.dart';
import 'package:fullstack_social_media_app/features/post/presentation/components/comment_tile.dart';
import 'package:fullstack_social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:fullstack_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:fullstack_social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // check for current user owner of post
  bool isOwnPost = false;

  // current user
  AppUser? currentUser;

  // post User
  ProfileUser? postUser;

  // on startup
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = widget.post.userId == currentUser!.uid;
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  /*
  LIKES
  */

  // user tapped like button
  void toggleLikePost() {
    // current like status
    final isLIked = widget.post.likes.contains(currentUser!.uid);

    // optimistically update UI
    setState(() {
      if (isLIked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    // update like
    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      // if there is an error revert back to original state
      setState(() {
        if (isLIked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  /*
  COMMENTS
  */
//comment text controller
  final commentTextController = TextEditingController();

  //open comment box--> user wants to type a new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
          controller: commentTextController,
          hintText: "Type a comment",
          obscureText: false,
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          // Save button
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void addComment() {
    // Create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: widget.post.userId,
      userName: widget.post.userName,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    // Add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  // show optionsfor deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          // delete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: Text(
              "Delete",
              style:
                  TextStyle(color: Colors.black, backgroundColor: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          // top section: profile pic / name / delete
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Profile Pic
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person_2),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Icon(Icons.person_2),

                const SizedBox(
                  width: 10,
                ),
                // Name
                Text(widget.post.userName),

                // Spacer
                const Spacer(),

                // delete button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  )
              ],
            ),
          ),
          // Image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: 430,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 430,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // bottom section: like / comment / timestamp
          Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            padding: EdgeInsets.all(6),
            child: Row(
              children: [
                // like button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.post.likes.length.toString(),
                        style: TextStyle(
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                // comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                Text(widget.post.comments.length.toString()),
                //Text("Comments:"),

                const SizedBox(
                  width: 20,
                ),

                // timestamp
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    widget.post.timestamp.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // CAPTION
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: [
                // Username
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                // Text
                Text(widget.post.text),

                // COMMENT SECTION
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    // LOADED
                    if (state is PostLoaded) {
                      // Final individual post
                      final post = state.posts
                          .firstWhere((post) => post.id == widget.post.id);

                      if (post.comments.isNotEmpty) {
                        // How many comments to show
                        int showCommentCount = post.comments.length;
                        // Comment section
                        return ListView.builder(
                          itemCount: showCommentCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // Get individual comment
                            final comment = post.comments[index];

                            // Comment tile UI
                            return CommentTile(comment: comment);
                          },
                        );
                      }
                    }
                    // LOADING..
                    if (state is PostLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ERROR
                    else if (state is PostError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
