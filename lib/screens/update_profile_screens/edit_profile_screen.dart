import 'package:city_of_carnation/screens/update_profile_screens/update_email_screen.dart';
import 'package:city_of_carnation/screens/update_profile_screens/update_name_screen.dart';
import 'package:city_of_carnation/screens/update_profile_screens/update_password_screen.dart';
import 'package:city_of_carnation/screens/update_profile_screens/update_phone_number.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/screens/update_profile_screens/update_profile_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.userData,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();

  final UserData userData;
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Update Profile Photo'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdateProfilePhotoScreen(
                    userData: widget.userData,
                  ),
                  settings: const RouteSettings(
                    name: 'UpdateProfilePhotoScreen',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Update Name'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdateNameScreen(
                    userData: widget.userData,
                  ),
                  settings: const RouteSettings(
                    name: 'UpdateNameScreen',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Update Email'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdateEmailScreen(
                    userData: widget.userData,
                  ),
                  settings: const RouteSettings(
                    name: 'UpdateEmailScreen',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Update Phone Number'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdatePhoneScreen(
                    userData: widget.userData,
                  ),
                  settings: const RouteSettings(
                    name: 'UpdateEmailScreen',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Update Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UpdatePasswordScreen(),
                  settings: const RouteSettings(
                    name: 'UpdatePasswordScreen',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
