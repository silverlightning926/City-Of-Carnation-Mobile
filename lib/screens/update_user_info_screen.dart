import 'package:city_of_carnation/managers/firestore_services.dart';
import 'package:city_of_carnation/screens/settings_screen.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen(
      {super.key, required this.updateType, required this.userData});

  final UpdateType updateType;
  final UserData userData;

  @override
  State<UpdateUserInfoScreen> createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  final TextEditingController _userInfoUpdateController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _userInfoUpdateController.text = widget.updateType == UpdateType.name
        ? widget.userData.name!
        : widget.updateType == UpdateType.email
            ? widget.userData.email!
            : widget.userData.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: widget.updateType == UpdateType.name
                  ? const Text('Update Name')
                  : widget.updateType == UpdateType.email
                      ? const Text('Update Email')
                      : const Text('Update Phone'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userInfoUpdateController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: widget.updateType == UpdateType.name
                          ? 'Full name'
                          : widget.updateType == UpdateType.email
                              ? 'Email'
                              : 'Phone',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.loaderOverlay.show();

                      final UserData newUserData = widget.userData;

                      widget.updateType == UpdateType.name
                          ? newUserData.name = _userInfoUpdateController.text
                          : widget.updateType == UpdateType.email
                              ? newUserData.email =
                                  _userInfoUpdateController.text
                              : newUserData.phone =
                                  _userInfoUpdateController.text;

                      FireStoreServices.updateUserData(
                              FirebaseAuth.instance.currentUser!.uid,
                              newUserData)
                          .then(
                        (value) {
                          context.loaderOverlay.hide();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.updateType == UpdateType.name
                                    ? 'Name Updated Successfully'
                                    : widget.updateType == UpdateType.email
                                        ? 'Email Updated Successfully'
                                        : 'Phone Updated Successfully',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
