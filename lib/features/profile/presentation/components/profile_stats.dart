/*

PROFILE STATS

this will display on all profile pages


No. of post, folowers, following

*/

import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats(
      {super.key,
      required this.postCount,
      required this.followerCount,
      required this.followingCount,
      required this.onTap,
      });

  //BUILD UI

  @overide
  Widget build(BuildContext context) {
    // text style for Count
    var textStyleForCount = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);

    //text style for text
    var textStyleForText =
        TextStyle(color: Theme.of(context).colorScheme.inversePrimary);

    return GestureDetector(
      onTap: onTap
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //posts
        SizedBox(
          width: 100,
          Column(
            children: [
              Text(postCount.toString(), style: textStyleForCount),
              Text("Posts", style: textStyleForText),
            ],
          ),
        ),

        //followers
        SizedBox(
          width: 100,
          Column(
            children: [
              Text(followerCount.toString(), style: textStyleForCount),
              Text("Followers", style: textStyleForText),
            ],
          ),
        ),

        //following
        SizedBox(
          width: 100,
          Column(
            children: [
              Text(followingCount.toString(), style: textStyleForText),
              Text("Following", style: textStyleForText),
            ],
          ),
        ),
      ],
    );
  }
}
