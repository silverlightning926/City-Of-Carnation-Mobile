import 'dart:io';

import 'package:city_of_carnation/screens/update_user_info_screen.dart';
import 'package:city_of_carnation/screens/welcome_screen.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

enum UpdateType { name, email, phone }

class SettingsScreen extends StatelessWidget {
  const SettingsScreen(
      {super.key, required this.userData, required this.userDataStream});

  final UserData userData;
  final Stream<UserData> userDataStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: userData,
      stream: userDataStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: SettingsList(
            darkTheme: const SettingsThemeData(
              settingsListBackground: Colors.black,
              settingsSectionBackground: Colors.black,
            ),
            applicationType: ApplicationType.both,
            platform: Platform.isAndroid
                ? DevicePlatform.android
                : DevicePlatform.iOS,
            sections: [
              SettingsSection(
                title: const Text('Account'),
                tiles: [
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.person,
                    ),
                    trailing: const Icon(
                      Icons.edit,
                      size: 15,
                    ),
                    title: const Text('Name'),
                    value: Text(userData.name!),
                    onPressed: (context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateUserInfoScreen(
                            userData: snapshot.data!,
                            updateType: UpdateType.name,
                          ),
                          settings:
                              const RouteSettings(name: 'UpdateNameScreen'),
                        ),
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.email,
                    ),
                    trailing: const Icon(
                      Icons.edit,
                      size: 15,
                    ),
                    title: const Text('Email'),
                    value: Text(userData.email!),
                    onPressed: (context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateUserInfoScreen(
                            userData: snapshot.data!,
                            updateType: UpdateType.email,
                          ),
                          settings:
                              const RouteSettings(name: 'UpdateEmailScreen'),
                        ),
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.phone,
                    ),
                    trailing: const Icon(
                      Icons.edit,
                      size: 15,
                    ),
                    title: const Text('Phone'),
                    value: Text(userData.phone!),
                    onPressed: (context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateUserInfoScreen(
                            userData: snapshot.data!,
                            updateType: UpdateType.phone,
                          ),
                          settings:
                              const RouteSettings(name: 'UpdatePhoneScreen'),
                        ),
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.logout,
                    ),
                    title: const Text('Sign Out'),
                    onPressed: (context) {
                      FirebaseAuth.instance.signOut().then(
                        (value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeScreen(),
                                settings: const RouteSettings(
                                  name: 'WelcomeScreen',
                                ),
                              ),
                              (route) => false);

                          FirebaseAnalytics.instance.logEvent(name: 'sign_out');
                        },
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('About'),
                tiles: [
                  SettingsTile.navigation(
                    title: const Text('Licenses'),
                    leading: const Icon(
                      Icons.gavel,
                    ),
                    onPressed: (context) {
                      showLicensePage(context: context);
                    },
                  ),
                  SettingsTile.navigation(
                    title: const Text('Info'),
                    leading: const Icon(
                      Icons.info,
                    ),
                    onPressed: (context) {
                      showAboutDialog(
                        context: context,
                        applicationLegalese:
                            'This application is under the Apache 2.0 License. Find more information at https://www.apache.org/licenses/LICENSE-2.0.txt',
                        applicationName: 'City of Carnation',
                        applicationVersion: '1.0.0',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
