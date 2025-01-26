/*
  FOLLOW BUTTON
    This is a follow / unfollow button

    ------------

    to use this widget, you need:
    - a function (toggleFollow)
    - isFollowing (bool)
 */

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final void Function()? onPressed;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding on left and right
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      //button
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          onPressed: onPressed,

          // padding inside
          padding: const EdgeInsets.all(10),
          // button color
          color:
              isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          // button text
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
