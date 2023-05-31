import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({
    super.key,
    required this.userData,
  });

  final UserData userData;

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.userData.email ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Update Email'),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter your current password and new email.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    EmailValidationResult emailValidationResult =
                        ValidationService.validateEmail(
                      _emailController.text,
                      oldEmail: widget.userData.email,
                    );

                    if (_passwordController.text.isEmpty ||
                        _emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill in all fields.',
                          ),
                        ),
                      );
                    } else {
                      if (emailValidationResult ==
                          EmailValidationResult.valid) {
                        context.loaderOverlay.show();
                        FocusManager.instance.primaryFocus?.unfocus();

                        try {
                          await AuthService.reauthenticateUser(
                            email: widget.userData.email!,
                            password: _passwordController.text,
                          );

                          await AuthService.updateUserEmail(
                            email: _emailController.text.trim(),
                          );

                          UserData newUserData = widget.userData;
                          newUserData.email = _emailController.text;

                          await FirestoreService.updateUserData(
                            AuthService.userId!,
                            newUserData,
                          );

                          if (context.mounted) {
                            Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            );
                          }
                        } catch (error) {
                          context.loaderOverlay.hide();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Something went wrong. Please try again.',
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ValidationService.getEmailErrorMessage(
                                emailValidationResult,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Update Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}