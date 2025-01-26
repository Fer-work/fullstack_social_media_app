// Profile user.dart
//class ProfileUser extends AppUser
final List<String> followers;
final List<String> following;

// ProfileUser 
required this.followers,
required this.following,

// ProfileUser Copywith
List<string>? newFollowers,
List<string>? newFollowing,

// return ProfileUser
followers: newFollowers ?? followers,
following: newFollowing ?? following,

// Map<string, dynamic> to json
'followers': followers,
'following': following,

//factory profileUser.fromJson
followers: List<String>.from(json['followers'] ?? []),
following: List<String>.from(json['following'] ?? []),







// firebase_profile_repo.dart
// if (userData != null)
    // fetch followers
    final followers = List<String>.from(userData['followers'] ?? []);
    final following = List<String>.from(userData['following'] ?? []);

    //return ProfileUser()
    followers: followers,
    following: following,

@override
Future<void> toggleFollow(String currentUid, String targetUid) async {
  try {

    final currentUserDoc = await firebaseFirestore.collection('users').doc(currentUid).get();
    final targetUserDoc = await firebaseFirestore.collection('users').doc(targetUid).get();

    if (currentUserDoc.exits && targetUserDoc.extis) {
      final currentUserData = currentUserDoc.data();
      final targetUserData = targetUserDoc.data();

      if (currentUserData != null && targetUserData != null) {
        final List<String> currentFollowing = List<String>.from(currentUserData['follwing'] ?? []);

        // check if the current user is already following the target user
        if (currentFollowing.contains(targetUid)) {
          //unfollow
          await firebaseFirestore.collection('users').doc(currentUid).update({
            'following': FieldValue.arrayRemove([targetUid])
          }); 
          await firebaseFirestore.collection('users').doc(targetUid).update({
            'followers': FieldValue.arrayRemove([currentUid])
          }); 
        }

        else {
          //follow
          await firebaseFirestore.collection('users').doc(currentUid).update({
            'following': FieldValue.arrayUnion([targetUid])
          }); 
          await firebaseFirestore.collection('users').doc(targetUid).update({
            'followers': FieldValue.arrayUnion([currentUid])
          }); 
        }
      }
    }

  }

  catch (e) {

  }
}





// profile_repo.dart
//abstract class ProfileRepo
Future<void> toggleFollow(String currentUid, String targetUid);






// profile_cubit.dart layer
// toggle follow/unfollow
Future<void> toggleFollow(String currentUserid, String targetUserid) async {
  try {

    await profileRepo.toggleFollow(currentUserid, targetUserid);
    await fetchUserProfile(targetUserid);
  }

  catch (e) {
    emit(ProfileError("Error Toggling follow: $e"));
  }
}


// New Component: follow_button.dart
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




// profile_page.dart
//above biobox
//follow button
FollowButton(
  onPressed: () {}, 
  isFollowing: false, 
),