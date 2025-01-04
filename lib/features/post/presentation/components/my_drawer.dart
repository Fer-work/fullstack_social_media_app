import 'package:flutter/material.dart';
import 'package:fullstack_social_media_app/features/post/presentation/components/my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // divider line
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),

              // home tile
              MyDrawerTile(
                title: "HOME",
                icon: Icons.home,
                onTap: () {},
              ),

              // profile tile
              MyDrawerTile(
                title: "PROFILE",
                icon: Icons.person,
                onTap: () {},
              ),

              // search tile
              MyDrawerTile(
                title: "SEARCH",
                icon: Icons.search,
                onTap: () {},
              ),

              // settings tile
              MyDrawerTile(
                title: "SETTINGS",
                icon: Icons.settings,
                onTap: () {},
              ),

              // logout tile
              MyDrawerTile(
                title: "LOGOUT",
                icon: Icons.logout,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
