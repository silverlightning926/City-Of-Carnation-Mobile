import 'package:city_of_carnation/screens/loading_screen.dart';
import 'package:city_of_carnation/screens/welcome_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        appBarTheme: AppBarTheme(
          color: Colors.black,
          titleTextStyle: Theme.of(context).textTheme.headline4!.copyWith(
                color: Colors.white,
                fontSize: 28,
              ),
        ),
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: FirebaseAnalytics.instance,
        ),
      ],
      home: FirebaseAuth.instance.currentUser == null
          ? const WelcomeScreen()
          : const LoadingScreen(),
    );
  }
}
