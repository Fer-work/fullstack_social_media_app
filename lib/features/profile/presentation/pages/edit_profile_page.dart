import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:fullstack_social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:fullstack_social_media_app/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

  // Web image pick
  Uint8List? webImage;

  // bio text controller
  final bioTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bioTextController.text = widget.user.bio;
  }

  // pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // update profile button pressed
  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    // prepare images & data
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    // only update profile if there is something to update
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    }

    // nothing to update, go to previous page
    else {
      Navigator.of(context).pop();
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // Profile loading...
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Uploading..."),
                ],
              ),
            ),
          );
        }
        // profile error
        else {
          // edit form
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit profile"),
        // foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // Save button
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile picture
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,
              child:
                  // display selected image for mobile
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                          File(imagePickedFile!.path!),
                          fit: BoxFit.cover,
                        )
                      :
                      // display selected image for web
                      (kIsWeb && webImage != null)
                          ? Image.memory(
                              webImage!,
                              fit: BoxFit.cover,
                            )
                          :
                          // No image selected, display existing profile image
                          CachedNetworkImage(
                              imageUrl: widget.user.profileImageUrl,
                              cacheKey: widget.user.uid,
                              // Loading placeholder
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: const CircularProgressIndicator(),
                                ),
                              ),

                              // Error widget, failed to load
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 72,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              // Loaded image
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
            ),
          ),

          // Spacing
          const SizedBox(height: 25),

          // Pick image button
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick image"),
            ),
          ),

          // Bio label
          Text(
            "Bio",
          ),

          // Spacing
          const SizedBox(height: 10),

          // Bio text field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextController,
              hintText: widget.user.bio,
              obscureText: false,
            ),
          ),
        ],
      ),
    );
  }
}
