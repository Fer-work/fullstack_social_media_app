import 'package:flutter/material.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/components/my_button.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;

  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // register button pressed
  void register() {
    // prepare info
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
  }

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

                // Create an account message
                Text(
                  "Let's create an account for you.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // name textfield
                MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),

                const SizedBox(
                  height: 10,
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

                // confirm password
                const SizedBox(
                  height: 10,
                ),

                // password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),

                const SizedBox(
                  height: 25,
                ),

                // Register button
                MyButton(onTap: () {}, text: 'Register'),

                const SizedBox(
                  height: 50,
                ),

                // already a member? Log in now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Login now",
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
