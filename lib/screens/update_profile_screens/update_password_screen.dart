import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter your current password and new password below.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _confirmNewPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (_passwordController.text.isEmpty ||
                        _newPasswordController.text.isEmpty ||
                        _confirmNewPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill in all fields.',
                          ),
                        ),
                      );
                    } else {
                      PasswordValidationResult passwordValidationResult =
                          ValidationService.validatePassword(
                        _newPasswordController.text,
                        _confirmNewPasswordController.text,
                        oldPassword: _passwordController.text,
                      );

                      if (passwordValidationResult ==
                          PasswordValidationResult.valid) {
                        context.loaderOverlay.show();
                        FocusManager.instance.primaryFocus?.unfocus();

                        try {
                          await AuthService.reauthenticateUser(
                            email: AuthService.userEmail!,
                            password: _passwordController.text,
                          );

                          await AuthService.updateUserPassword(
                            password: _newPasswordController.text,
                          );

                          if (context.mounted) {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
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
                              ValidationService.getPasswordErrorMessage(
                                passwordValidationResult,
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
        ],
      ),
    );
  }
}
