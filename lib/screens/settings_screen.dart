import 'dart:io';

import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:flutter/material.dart';
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
