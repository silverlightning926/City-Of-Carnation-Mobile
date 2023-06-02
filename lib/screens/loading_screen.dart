import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:city_of_carnation/screens/home_screen.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    Stream<UserData> userDataStream =
        FirestoreService.getUserDataStream(AuthService.userId!);

    Stream<List<WorkOrder>> workOrderStream =
        FirestoreService.getWorkOrderStream();

    Future.wait(
      [
        FirestoreService.getUserData(AuthService.userId!),
        FirestoreService.getPostData(),
        FirestoreService.getEventData(),
        FirestoreService.getWorkOrders(),
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

        AnalyticsService.setUserId();

        AnalyticsService.setUserProperties(name: 'name', value: userData.name!);
        AnalyticsService.setUserProperties(
            name: 'email', value: userData.email!);
        AnalyticsService.setUserProperties(
            name: 'phone', value: userData.phone!);

        AnalyticsService.logLogin();

        AnalyticsService.logEvent(
          name: 'app_open',
          parameters: <String, dynamic>{
            'user_id': AuthService.userId,
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ScaffoldGradientBackground(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color.fromARGB(255, 37, 7, 128),
          Color(0xFF030417),
          Color(0xFF03040c),
        ],
      ),
      body: Center(
        child: SpinKitFadingCube(
          size: 100.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
