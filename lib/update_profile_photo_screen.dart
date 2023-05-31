import 'dart:io';

import 'package:city_of_carnation/components/avatar/profile_picture.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/cloud_storage_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateProfilePhotoScreen extends StatefulWidget {
  const UpdateProfilePhotoScreen({
    super.key,
    required this.userData,
  });

  final UserData userData;

  @override
  State<UpdateProfilePhotoScreen> createState() =>
      _UpdateProfilePhotoScreenState();
}

class _UpdateProfilePhotoScreenState extends State<UpdateProfilePhotoScreen> {
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Update Profile Photo'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Ink(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Camera'),
                                onTap: () async {
                                  final image = await ImagePicker().pickImage(
                                    source: ImageSource.camera,
                                  );
                                  setState(() {
                                    _imageFile = image;
                                  });
                                  if (mounted) Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text('Gallery'),
                                onTap: () async {
                                  final image = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  setState(() {
                                    _imageFile = image;
                                  });
                                  if (mounted) Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    customBorder: const CircleBorder(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ProfilePicture(
                          img: widget.userData.profilePicture,
                          name: widget.userData.name!,
                          radius: 75,
                          fontsize: 50,
                        ),
                        if (_imageFile != null)
                          CircleAvatar(
                            radius: 75,
                            foregroundImage: FileImage(
                              File(_imageFile!.path),
                            ),
                          ),
                        Icon(
                          Icons.edit,
                          size: 50,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    context.loaderOverlay.show();

                    if (_imageFile != null) {
                      context.loaderOverlay.show();
                      CloudStorageService.updateUserProfilePhoto(
                        imageFile: File(_imageFile!.path),
                      ).then((value) {
                        UserData userData = widget.userData;
                        userData.profilePicture = value;
                        FirestoreService.updateUserData(
                          AuthService.userId!,
                          userData,
                        ).then((value) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        });
                      });
                    } else {
                      context.loaderOverlay.hide();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No Photo Selected'),
                        ),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
