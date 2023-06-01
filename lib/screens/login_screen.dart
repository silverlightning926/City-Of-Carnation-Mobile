import 'package:city_of_carnation/screens/forgot_password_screen.dart';
import 'package:city_of_carnation/screens/loading_screen.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isErrored = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          SvgPicture.asset(
            './assets/images/login_screen_image.svg',
            width: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Login",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          Column(
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                    'Something went wrong. Please try again.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  context.loaderOverlay.show();
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      ValidationService.validateEmail(_emailController.text) !=
                          EmailValidationResult.valid) {
                    setState(() {
                      isErrored = true;
                    });
                    context.loaderOverlay.hide();
                    return;
                  }

                  try {
                    await AuthService.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ).then((value) => {
                          context.loaderOverlay.hide(),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoadingScreen(),
                              settings: const RouteSettings(
                                name: 'LoadingScreen',
                              ),
                            ),
                          ),
                        });
                  } catch (e) {
                    setState(() {
                      isErrored = true;
                    });
                    context.loaderOverlay.hide();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                ),
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ForgotPasswordScreen();
                  }));
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
