import 'package:city_of_carnation/components/avatar/profile_picture.dart';
import 'package:city_of_carnation/screens/settings_screen.dart';
import 'package:city_of_carnation/screens/update_profile_screens/edit_profile_screen.dart';
import 'package:city_of_carnation/screens/welcome_screen.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.userData,
    required this.userDataStream,
  });

  final UserData userData;
  final Stream<UserData> userDataStream;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
          stream: userDataStream,
          initialData: userData,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            userData: snapshot.data!,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            userData: snapshot.data!,
                            userDataStream: userDataStream,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        ProfilePicture(
                          name: snapshot.data!.name!,
                          radius: 70,
                          fontsize: 45,
                          img: userData.profilePicture,
                        ),
                        const SizedBox(height: 35),
                        Center(
                          child: Text(
                            snapshot.data!.name!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            'Joined On ${DateFormat.yMMMMd().format(
                              AuthService.user!.metadata.creationTime!
                                  .toLocal(),
                            )}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text(
                            snapshot.data!.email!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: Text(
                            '${snapshot.data!.phone!.substring(
                                  snapshot.data!.phone!.length - 10,
                                ).substring(0, 3)}-${snapshot.data!.phone!.substring(
                                  snapshot.data!.phone!.length - 10,
                                ).substring(3, 6)}-${snapshot.data!.phone!.substring(
                                  snapshot.data!.phone!.length - 10,
                                ).substring(6, 10)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        AuthService.signOut().then(
                          (value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeScreen(),
                                settings: const RouteSettings(
                                  name: 'WelcomeScreen',
                                ),
                              ),
                              (route) => false),
                        );

                        AnalyticsService.logEvent(name: 'logout');
                        AnalyticsService.removeUserId();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 10),
                            Text('Logout'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}