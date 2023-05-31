import 'package:city_of_carnation/screens/loading_screen.dart';
import 'package:city_of_carnation/screens/welcome_screen.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CityOfCarnation());
}

class CityOfCarnation extends StatelessWidget {
  const CityOfCarnation({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Of Carnation',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.teal[200],
          unselectedItemColor: Colors.grey,
        ),
      ),
      navigatorObservers: [
        AnalyticsService.analyticsObserver,
      ],
      home: AuthService.user == null
          ? const WelcomeScreen()
          : const LoadingScreen(),
    );
  }
}
