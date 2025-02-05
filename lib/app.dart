import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/pages/auth_page.dart';
import 'package:fullstack_social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:fullstack_social_media_app/features/post/data/firebase_post_repo.dart';
import 'package:fullstack_social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:fullstack_social_media_app/features/profile/data/firebase_profile_repo.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:fullstack_social_media_app/features/search/data/firebase_search_repo.dart';
import 'package:fullstack_social_media_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:fullstack_social_media_app/features/storage/data/firebase_storage_repo.dart';
import 'package:fullstack_social_media_app/themes/light_mode.dart';

/*

APP - Root Level

Repositories: for the database
  - firebase

Bloc Providers: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unathenticated -> auth page (login / register)
  - authenticated -> home page

*/

class MyApp extends StatelessWidget {
  // auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  // profile repo
  final firebaseProfileRepo = FirebaseProfileRepo();

  // Storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();

  // post repo
  final firebasePostRepo = FirebasePostRepo();

  // search repo
  final firebaseSearchRepo = FirebaseSearchRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide cubits to our app
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        // Post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        // search cubit. BlocProvider is a Bloc widget that injects a Cubit instance into the widget tree, ensures that state management is easily accesible to child widgets
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
          print(authState);
          // - unathenticated -> auth page (login / register)
          if (authState is Unauthenticated) {
            return const AuthPage();
          }

          // - authenticated -> home page
          if (authState is Authenticated) {
            return const HomePage();
          }

          // loading...
          else {
            return const Scaffold(body: CircularProgressIndicator());
          }
        },
            // listen for errors...
            listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        }),
      ),
    );
  }
}
