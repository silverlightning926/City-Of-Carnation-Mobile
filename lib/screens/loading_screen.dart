import 'package:city_of_carnation/managers/firestore_manager.dart';
import 'package:city_of_carnation/screens/home_screen.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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

    FirebaseAnalytics.instance.setUserId(
      id: FirebaseAuth.instance.currentUser!.uid,
    );

    Stream<QuerySnapshot<Map<String, dynamic>>> workOrderStream =
        FireStoreManager.getWorkOrderStream(
            FirebaseAuth.instance.currentUser!.uid);

    Future.wait(
      [
        FireStoreManager.getUserData(FirebaseAuth.instance.currentUser!.uid),
        FireStoreManager.getPostData(),
        FireStoreManager.getEventData(),
      ],
    ).then(
      (value) {
        final UserData userData = value[0] as UserData;
        final List<Post> posts = value[1] as List<Post>;
        final List<Event> events = value[2] as List<Event>;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userData: userData,
              posts: posts,
              events: events,
              workOrders: workOrderStream,
            ),
            settings: const RouteSettings(name: 'HomeScreen'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: SpinKitFadingCube(
            size: 100.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
