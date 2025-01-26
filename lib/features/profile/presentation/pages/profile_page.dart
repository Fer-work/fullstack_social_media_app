import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:fullstack_social_media_app/features/post/presentation/components/post_tile.dart';
import 'package:fullstack_social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:fullstack_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/components/bio_box.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/components/follow_button.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/components/profile_stats.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/pages/follower_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;

  // on startup
  @override
  void initState() {
    super.initState();

    // load the user profile
    if (currentUser != null) {
      profileCubit.fetchUserProfile(widget.uid);
    }
  }

  /*
  Follow / Unfollow
  */
  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) return;

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    // optimistically update the UI
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    // toggle follow
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      // revert update if there's an error
      if (isFollowing) {
        profileUser.followers.add(currentUser!.uid);
      } else {
        profileUser.followers.remove(currentUser!.uid);
      }
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // is own post?
    bool isOwnPost = (widget.uid == currentUser!.uid);

    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // loaded
        if (state is ProfileLoaded) {
          final user = state.profileUser;

          return Scaffold(
            // App Bar
            appBar: AppBar(
              title: Center(child: Text(user.name)),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                if (isOwnPost)
                  // edit profile button
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ),
                    ),
                    icon: Icon(Icons.settings),
                  ),
              ],
            ),

            // Body
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // email
                      Center(
                        child: Text(
                          user.email,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),

                      SizedBox(height: 25),

                      // Profile Image
                      CachedNetworkImage(
                        imageUrl: user.profileImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          size: 72,
                          color: Theme.of(context).colorScheme.primary,
                        ),

                        // loaded
                        imageBuilder: (context, imageProvider) => Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      // profile stats
                      ProfileStats(
                        postCount: postCount,
                        followerCount: user.followers.length,
                        followingCount: user.following.length,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowerPage(
                              followers: user.followers,
                              following: user.following,
                            ),
                          ),
                        ),
                      ),

                      if (!isOwnPost)
                        // follow button
                        FollowButton(
                            onPressed: followButtonPressed,
                            isFollowing:
                                user.followers.contains(currentUser!.uid)),

                      SizedBox(height: 25),

                      // bio box
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: [
                            Text(
                              "Bio",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      BioBox(text: user.bio),

                      // posts
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 25),
                        child: Row(
                          children: [
                            Text(
                              "Posts",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      // Post List
                      BlocBuilder<PostCubit, PostState>(
                        builder: (context, state) {
                          // posts loaded...
                          if (state is PostLoaded) {
                            // filter posts by user id
                            final userPosts = state.posts
                                .where((post) => post.userId == user.uid)
                                .toList();

                            postCount = userPosts.length;

                            return Expanded(
                              child: ListView.builder(
                                itemCount: postCount,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final post = userPosts[index];

                                  return PostTile(
                                    post: post,
                                    onDeletePressed: () => context
                                        .read<PostCubit>()
                                        .deletePost(post.id),
                                  );
                                },
                              ),
                            );
                          }
                          // posts loading
                          else if (state is PostLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // error
                          else {
                            return const Center(
                              child: Text("No posts found.."),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProfileLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // errors
        else if (state is ProfileError) {
          return Center(
            child: Text("Error: ${state.message}"),
          );
        } else {
          return const Center(
            child: Text("No profile found.."),
          );
        }
      },
    );
  }
}
