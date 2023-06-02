import 'dart:io';

import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:settings_ui/settings_ui.dart';

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
            title: const Text('Settings'),
          ),
          body: SettingsList(
            darkTheme: const SettingsThemeData(
              settingsListBackground: Colors.transparent,
              settingsSectionBackground: Colors.transparent,
            ),
            applicationType: ApplicationType.both,
            platform: Platform.isAndroid
                ? DevicePlatform.android
                : DevicePlatform.iOS,
            sections: [
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
