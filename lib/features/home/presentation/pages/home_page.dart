import 'package:flutter/material.dart';
import 'package:fullstack_social_media_app/features/home/presentation/components/my_drawer.dart';
import 'package:fullstack_social_media_app/features/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload new post button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // navigate to the create post page
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UploadPostPage();
              }));
            },
          ),
        ],
      ),

      // Drawer
      drawer: MyDrawer(),
    );
  }
}
