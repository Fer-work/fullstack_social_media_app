import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/pages/auth_page.dart';
import 'package:fullstack_social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:fullstack_social_media_app/features/profile/data/firebase_profile_repo.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:fullstack_social_media_app/features/profile/domain/repos/profile_repo.dart';
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
  final authRepo = FirebaseAuthRepo();

  // profile repo
  final profileRepo = FirebaseProfileRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide cubits to our app
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepo: profileRepo),
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
