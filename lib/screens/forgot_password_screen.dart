import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  bool isErrored = false;
  String errorMessage = 'Something went wrong. Please try again.';

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
        title: const Text('Forgot Password'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Enter your email address and we will send you a link to reset your password.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          Visibility(
            visible: isErrored,
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(70, 244, 67, 54),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              context.loaderOverlay.show();
              final emailValidationResult =
                  ValidationService.validateEmail(_emailController.text);

              if (emailValidationResult != EmailValidationResult.valid) {
                context.loaderOverlay.hide();
                setState(() {
                  isErrored = true;
                  errorMessage = ValidationService.getEmailErrorMessage(
                    emailValidationResult,
                  );
                });
              } else {
                try {
                  await AuthService.sendPasswordResetEmail(
                    email: _emailController.text,
                  );

                  setState(() {
                    isErrored = false;
                  });

                  if (context.mounted) {
                    context.loaderOverlay.hide();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'If the email address is registered, you will receive a password reset link. Please check your email.',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  context.loaderOverlay.hide();
                  setState(() {
                    isErrored = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'If the email address is registered, you will receive a password reset link. Please check your email.',
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }
}
