import 'package:city_of_carnation/screens/loading_screen.dart';
import 'package:city_of_carnation/screens/welcome_screen.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          enableFeedback: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      navigatorObservers: [
        AnalyticsService.analyticsObserver,
      ],
      builder: (context, child) {
        return SafeArea(
          child: LoaderOverlay(
            overlayColor: Colors.black.withOpacity(0.5),
            overlayWidget: const Center(
              child: CircularProgressIndicator(),
            ),
            child: child!,
          ),
        );
      },
      home: AuthService.user == null
          ? const WelcomeScreen()
          : const LoadingScreen(),
    );
  }
}
