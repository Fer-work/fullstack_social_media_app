import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';

import '../components/user_tile.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // tab controller
    return DefaultTabController(
      length: 2,

      //Scaffold
      child: Scaffold(
        // App bar
        appBar: AppBar(

          // Tab bar
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: "Followers"),
              Tab(text: "Following"),
          ]),
        ),
      ),

      // Tab bar view
      body: TabBarView(
        children: [
          _buildUserList(followers, "No Followers", context),
          _buildUserList(following, "No following", context),
        ],
      ),
    );
  }

  // build user list, given a list of profile uids

  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              // get each uid
              final uid = uids[index];

              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  // user loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    return UserTile(user: user);
                  }

                  //loading...
                  else if (snapshot.connection == ConnectionState.waiting) {
                    return ListTile(title: Text("Loading.."));
                  }

                  // not found
                   else (
                      return ListTile(title: Text("User not found"));
                   )
                },
              );
            },
          );
  }
}
