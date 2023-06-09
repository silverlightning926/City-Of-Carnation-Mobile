import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class UpdateNameScreen extends StatefulWidget {
  const UpdateNameScreen({
    super.key,
    required this.userData,
  });

  final UserData userData;

  @override
  State<UpdateNameScreen> createState() => _UpdateNameScreenState();
}

class _UpdateNameScreenState extends State<UpdateNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData.name ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color.fromARGB(255, 37, 7, 128),
          Color(0xFF030417),
          Color(0xFF03040c),
        ],
      ),
      appBar: AppBar(
        title: const Text('Update Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                context.loaderOverlay.show();
                NameValidationResult nameValidationResult =
                    ValidationService.validateName(
                  _nameController.text,
                  oldName: widget.userData.name,
                );

                if (nameValidationResult != NameValidationResult.valid) {
                  context.loaderOverlay.hide();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ValidationService.getNameErrorMessage(
                          nameValidationResult,
                        ),
                      ),
                    ),
                  );
                  return;
                } else {
                  UserData newUserData = widget.userData;
                  newUserData.name = _nameController.text;

                  FirestoreService.updateUserData(
                    AuthService.userId!,
                    newUserData,
                  ).then(
                    (value) {
                      context.loaderOverlay.hide();
                      Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      );
                    },
                  );

                  AnalyticsService.setUserProperties(
                    name: 'name',
                    value: _nameController.text,
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
