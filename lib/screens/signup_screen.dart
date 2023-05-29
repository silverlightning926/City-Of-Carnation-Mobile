import 'package:city_of_carnation/managers/firestore_manager.dart';
import 'package:city_of_carnation/screens/loading_screen.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:validation_pro/validate.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isErrored = false;
  String errorMessage = 'Something went wrong. Please try again.';

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    "Register",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s")),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InternationalPhoneNumberInput(
                      ignoreBlank: true,
                      onInputChanged: (PhoneNumber number) {},
                      textFieldController: _phoneController,
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        trailingSpace: false,
                      ),
                      formatInput: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                      inputDecoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 10,
                      initialValue: PhoneNumber(
                        isoCode: 'US',
                        dialCode: '+1',
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
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                      onPressed: () {
                        context.loaderOverlay.show();
                        if (_nameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _phoneController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _confirmPasswordController.text.isEmpty) {
                          setState(() {
                            isErrored = true;
                            errorMessage = 'Please fill all the fields.';
                          });

                          context.loaderOverlay.hide();
                        } else if (!Validate.isEmail(
                          _emailController.text.trim(),
                        )) {
                          setState(() {
                            isErrored = true;
                            errorMessage = 'Please enter a valid email.';
                          });

                          context.loaderOverlay.hide();
                        } else if (!RegExp(
                          r'^[0-9]{10}$',
                        ).hasMatch(
                          _phoneController.text.trim(),
                        )) {
                          setState(() {
                            isErrored = true;
                            errorMessage = 'Please enter a valid phone number.';
                          });

                          context.loaderOverlay.hide();
                        } else if (_passwordController.text.trim() !=
                            _confirmPasswordController.text.trim()) {
                          setState(() {
                            isErrored = true;
                            errorMessage = 'Passwords do not match.';
                          });

                          context.loaderOverlay.hide();
                        } else if (!Validate.isPassword(
                          _passwordController.text.trim(),
                        )) {
                          setState(() {
                            isErrored = true;
                            errorMessage =
                                'Password must be 6 - 12 characters long. It must contain at least one uppercase letter, one lowercase letter, one number and one special character.';
                          });

                          context.loaderOverlay.hide();
                        } else if (_nameController.text.length > 20) {
                          setState(() {
                            isErrored = true;
                            errorMessage =
                                'Name must be at most 20 characters long.';
                          });

                          context.loaderOverlay.hide();
                        } else if (_phoneController.text.length > 10) {
                          setState(() {
                            isErrored = true;
                            errorMessage =
                                'Phone number must be at most 10 characters long.';
                          });

                          context.loaderOverlay.hide();
                        } else if (_emailController.text.length > 30) {
                          setState(() {
                            isErrored = true;
                            errorMessage =
                                'Email must be at most 30 characters long.';
                          });

                          context.loaderOverlay.hide();
                        } else if (_confirmPasswordController.text.length >
                            15) {
                          setState(() {
                            isErrored = true;
                            errorMessage =
                                'Password must be at most 15 characters long.';
                          });

                          context.loaderOverlay.hide();
                        } else {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          )
                              .then((value) {
                            UserData user = UserData(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim(),
                              uid: value.user!.uid,
                            );

                            FireStoreManager.addUserData(
                              value.user!.uid,
                              user,
                            ).then(
                              (value) {
                                FirebaseAnalytics.instance
                                    .logLogin(loginMethod: 'email');

                                context.loaderOverlay.hide();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoadingScreen(),
                                    settings: const RouteSettings(
                                        name: 'LoadingScreen'),
                                  ),
                                  (route) => false,
                                );
                              },
                            );
                          }).catchError((error) {
                            setState(() {
                              isErrored = true;
                              errorMessage =
                                  'Something went wrong. Please try again.';
                            });

                            context.loaderOverlay.hide();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 75),
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                      child: const Text('Register'),
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
