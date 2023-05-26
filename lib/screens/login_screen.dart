import 'package:city_of_carnation/screens/loading_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoaderOverlay(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  './assets/images/login_screen_image.svg',
                  width: 200,
                ),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
                Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
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
                  visible: false,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(70, 244, 67, 54),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error Message',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.loaderOverlay.show();
                        try {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              )
                              .then((value) => {
                                    context.loaderOverlay.hide(),
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoadingScreen(),
                                        settings: const RouteSettings(
                                          name: 'LoadingScreen',
                                        ),
                                      ),
                                    ),
                                    FirebaseAnalytics.instance
                                        .logLogin(loginMethod: 'email'),
                                  });
                        } on FirebaseAuthException catch (exception) {
                          context.loaderOverlay.hide();
                          // TODO: Handle FirebaseAuthException With Error Message
                          if (exception.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (exception.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 75),
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
