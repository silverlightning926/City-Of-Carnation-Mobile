import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:city_of_carnation/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdatePhoneScreen extends StatefulWidget {
  const UpdatePhoneScreen({
    super.key,
    required this.userData,
  });

  final UserData userData;

  @override
  State<UpdatePhoneScreen> createState() => _UpdatePhoneScreenState();
}

class _UpdatePhoneScreenState extends State<UpdatePhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();

  late String phoneLocale;

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.userData.phone!;
    phoneLocale = widget.userData.phoneLocale!;
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InternationalPhoneNumberInput(
              onInputChanged: (value) {
                phoneLocale = value.isoCode!;
              },
              autoValidateMode: AutovalidateMode.disabled,
              formatInput: false,
              textFieldController: _phoneController,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              inputDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number',
              ),
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                trailingSpace: false,
              ),
              initialValue: PhoneNumber(
                phoneNumber: widget.userData.phone!,
                isoCode: widget.userData.phoneLocale!,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                final phoneValidationResult = ValidationService.validatePhone(
                  _phoneController.text,
                  oldPhone: widget.userData.phone,
                );

                if (phoneValidationResult != PhoneValidationResult.valid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ValidationService.getPhoneErrorMessage(
                          phoneValidationResult,
                        ),
                      ),
                    ),
                  );
                  return;
                } else {
                  context.loaderOverlay.show();

                  UserData newUserData = widget.userData;
                  newUserData.phone = _phoneController.text;
                  newUserData.phoneLocale = phoneLocale;

                  FirestoreService.updateUserData(
                    AuthService.userId!,
                    newUserData,
                  ).then(
                    (value) => Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    ),
                  );

                  AnalyticsService.setUserProperties(
                    name: 'phone',
                    value: _phoneController.text,
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
