import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:city_of_carnation/screens/loading_screen.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loader_overlay/loader_overlay.dart';

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

  String phoneLocale = 'US';

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
          appBar: AppBar(),
          body: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    onInputChanged: (PhoneNumber number) {
                      phoneLocale = number.isoCode!;
                    },
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
                    onPressed: () {
                      context.loaderOverlay.show();

                      NameValidationResult nameValidationResult =
                          ValidationService.validateName(
                        _nameController.text,
                      );

                      if (nameValidationResult != NameValidationResult.valid) {
                        setState(() {
                          isErrored = true;
                          errorMessage = ValidationService.getNameErrorMessage(
                              nameValidationResult);
                        });
                        context.loaderOverlay.hide();
                        return;
                      }

                      EmailValidationResult emailValidationResult =
                          ValidationService.validateEmail(
                        _emailController.text,
                      );

                      if (emailValidationResult ==
                          EmailValidationResult.invalid) {
                        setState(() {
                          isErrored = true;
                          errorMessage = ValidationService.getEmailErrorMessage(
                              emailValidationResult);
                        });
                        context.loaderOverlay.hide();
                        return;
                      }

                      PhoneValidationResult phoneValidationResult =
                          ValidationService.validatePhone(
                        _phoneController.text,
                      );

                      if (phoneValidationResult !=
                          PhoneValidationResult.valid) {
                        setState(() {
                          isErrored = true;
                          errorMessage = ValidationService.getPhoneErrorMessage(
                              phoneValidationResult);
                        });
                        context.loaderOverlay.hide();
                        return;
                      }

                      PasswordValidationResult passwordValidationResult =
                          ValidationService.validatePassword(
                        _passwordController.text,
                        _confirmPasswordController.text,
                      );

                      if (passwordValidationResult !=
                          PasswordValidationResult.valid) {
                        setState(() {
                          isErrored = true;
                          errorMessage =
                              ValidationService.getPasswordErrorMessage(
                                  passwordValidationResult);
                        });
                        context.loaderOverlay.hide();
                        return;
                      }

                      createUser().then((value) {
                        context.loaderOverlay.hide();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoadingScreen(),
                            settings:
                                const RouteSettings(name: 'LoadingScreen'),
                          ),
                          (route) => false,
                        );
                      }).catchError(
                        (error) {
                          setState(() {
                            isErrored = true;
                            errorMessage =
                                'Something went wrong! Please try again.';
                          });
                          context.loaderOverlay.hide();

                          return error;
                        },
                      );
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
    );
  }

  Future<void> createUser() async {
    UserCredential userCredential =
        await AuthService.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    UserData user = UserData(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      phoneLocale: phoneLocale.trim(),
      profilePicture: null,
      uid: userCredential.user!.uid,
    );

    await FirestoreService.addUserData(
      userCredential.user!.uid,
      user,
    );
  }
}
