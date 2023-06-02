import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

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
    return SafeArea(
      child: ScaffoldGradientBackground(
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
          title: const Text('Update Email'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter your current password and new email.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
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
                    if (emailValidationResult == EmailValidationResult.valid) {
                      context.loaderOverlay.show();
                      FocusManager.instance.primaryFocus?.unfocus();

                      try {
                        await AuthService.reauthenticateUser(
                          email: widget.userData.email!,
                          password: _passwordController.text,
                        );

                        await AuthService.updateUserEmail(
                          email: _emailController.text,
                        );

                        UserData newUserData = widget.userData;
                        newUserData.email = _emailController.text;

                        await FirestoreService.updateUserData(
                          AuthService.userId!,
                          newUserData,
                        );

                        if (context.mounted) {
                          context.loaderOverlay.hide();
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
    );
  }
}
