import 'package:city_of_carnation/screens/login_screen.dart';
import 'package:city_of_carnation/screens/welcome_screen.dart';
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
      theme: ThemeData.dark().copyWith(),
      home: const WelcomeScreen(),
    );
  }
}
