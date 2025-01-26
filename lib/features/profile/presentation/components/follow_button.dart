import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {

  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key
    required this.onPressed,
    required this.isFollowing,
    
    });

  //Build UI
  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInserts.symmetric(horizontal: 25.0),

      child: ClipRRect(
      child: MaterialButton(
      onPressed: onPressed,


      color: isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue, 


      child: Text(isFollowing ? "Unfollow": "Follow"),
      ),
      ),
    );
  }
}