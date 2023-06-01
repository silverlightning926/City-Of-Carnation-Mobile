import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
    return LoaderOverlay(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Forgot Password'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Enter your email address and we will send you a link to reset your password.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
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
        ),
      ),
    );
  }
}
