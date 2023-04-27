import 'package:city_of_carnation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
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
