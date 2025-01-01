/*

LOGIN PAGE

On this page, an existing user can logi with their:

- email
- password (pw)

---------------------------------------------------------------------------------------

Once the user successfully logs in, they will be redirected to home page. 

If user doesn't have an account yet, they can to the register page from here to create one. 
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/components/my_button.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;

  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text controller
  final emailController = TextEditingController();

  // password controller
  final passwordController = TextEditingController();

  // login button pressed
  void login() {
    // prepare email & password
    final String email = emailController.text;
    final String password = passwordController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure that the email and password fields are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    }

    // display error if some fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter both email and password")));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(
                  height: 50,
                ),

                // Welcome back message
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(
                  height: 10,
                ),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(
                  height: 25,
                ),

                // login button
                MyButton(onTap: login, text: 'Login'),

                const SizedBox(
                  height: 50,
                ),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member yet?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Register now",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
