import 'package:city_of_carnation/managers/firestore_manager.dart';
import 'package:city_of_carnation/screens/home_screen.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    Future.wait(
      [
        FireStoreManager.getUserData(FirebaseAuth.instance.currentUser!.uid),
        FireStoreManager.getPostData(),
      ],
    ).then(
      (value) {
        final UserData userData = value[0] as UserData;
        final List<Post> posts = value[1] as List<Post>;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userData: userData, posts: posts),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitFadingCube(
          size: 100.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
