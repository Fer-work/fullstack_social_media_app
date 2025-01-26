import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/components/bio_box.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/pages/edit_profile_page.dart';

import '../../../../Sahil/Follow_Feature.dart';
import '../components/follow_button.dart';
import '../cubits/profile_states.dart';

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

  // on startup
  @override
  void initState() {
    super.initState();

    // load the user profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  /*

  FOLLOW/UNFOLLOW
  
  */

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return; // return is profile is not loaded
    }

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    // opmistically update UI
    setState(() {
      // unfollow
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      }

      // follow
      else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    // perform actual toggle in cubit
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      // revert update if there is an error
      setState(() {
        // unfollow
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        }

        // follow
        else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // is own
    bool isOwnPost = (widget.uid == currentUser!.uid);

    return BlocBuilder<ProfileCubit, ProfileStates>(builder: (context, state) {
      // loaded
      if (state is ProfileLoaded) {
        // get loaded user
        final user = state.profileUser;

        // SCAFFOLD
        return Scaffold(
          appBar: AppBar(
            title: Text(user.name),
            foregroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              // edit profile button

              if (isOwnPost)
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      )),
                  icon: Icon(Icons.settings),
                )
            ],
          ),

          // Body
          body: Column(
            children: [
              // profile email
              Text(
                user.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),

              // Spacing
              SizedBox(
                height: 25,
              ),

              // profile picture
              CachedNetworkImage(
                imageUrl: user.profileImageUrl,
                cacheKey: user.uid,
                // loading...
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: const CircularProgressIndicator(),
                  ),
                ),

                fit: BoxFit.cover,
                // error, failed to load
                errorWidget: (context, url, error) => Icon(Icons.error,
                    size: 72, color: Theme.of(context).colorScheme.primary),
                // loaded
                imageBuilder: (context, imageProvider) => Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),

              // Spacing
              SizedBox(
                height: 25,
              ),

              //profile stats
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

              const SizedBox(height: 25),

              //follow button

              if (!isOwnPost)
                FollowButton(
                  onPressed: followButtonPressed,
                  isFollowing: user.followers.contains(currentUser!.uid),
                ),

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

              // Spacing
              SizedBox(
                height: 10,
              ),

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
            ],
          ),
        );
      }
      // loading
      else if (state is ProfileLoading) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return const Center(
          child: Text("No profile found.."),
        );
      }
    });
  }
}
