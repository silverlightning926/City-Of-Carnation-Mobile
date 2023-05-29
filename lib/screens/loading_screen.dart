import 'package:city_of_carnation/managers/firestore_services.dart';
import 'package:city_of_carnation/screens/home_screen.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
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

    Stream<UserData> userDataStream = FireStoreServices.getUserDataStream(
        FirebaseAuth.instance.currentUser!.uid);

    Stream<List<WorkOrder>> workOrderStream =
        FireStoreServices.getWorkOrderStream(
            FirebaseAuth.instance.currentUser!.uid);

    Future.wait(
      [
        FireStoreServices.getUserData(FirebaseAuth.instance.currentUser!.uid),
        FireStoreServices.getPostData(),
        FireStoreServices.getEventData(),
        FireStoreServices.getWorkOrders(FirebaseAuth.instance.currentUser!.uid),
      ],
    ).then(
      (value) {
        final UserData userData = value[0] as UserData;
        final List<Post> posts = value[1] as List<Post>;
        final List<Event> events = value[2] as List<Event>;
        final List<WorkOrder> workOrders = value[3] as List<WorkOrder>;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userData: userData,
              userDataStream: userDataStream,
              posts: posts,
              events: events,
              workOrders: workOrders,
              workOrderStream: workOrderStream,
            ),
            settings: const RouteSettings(name: 'HomeScreen'),
          ),
        );

        FirebaseAnalytics.instance.setUserId(
          id: FirebaseAuth.instance.currentUser!.uid,
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
