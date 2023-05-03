import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "City of Carnation",
            ),
            actions: [
              IconButton(
                onPressed: () {
                  try {
                    FirebaseAuth.instance.signOut().then(
                          (value) => Navigator.pushNamedAndRemoveUntil(
                              context, '/welcome', (route) => false),
                        );
                  } on FirebaseAuthException catch (exception) {
                    print(exception);
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                ),
              ),
            ],
          ),
          body: ListView(
            children: [],
          ),
        ),
      ),
    );
  }
}
