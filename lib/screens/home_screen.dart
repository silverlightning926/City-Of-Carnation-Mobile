import 'package:city_of_carnation/screens/tabs/events_tab.dart';
import 'package:city_of_carnation/screens/tabs/feed_tab.dart';
import 'package:city_of_carnation/screens/tabs/home_tab.dart';
import 'package:city_of_carnation/screens/tabs/notify_tab.dart';
import 'package:city_of_carnation/screens/welcome_screen.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userData,
    required this.posts,
    required this.events,
    required this.workOrders,
  });

  final UserData userData;
  final List<Post> posts;
  final List<Event> events;
  final Stream<QuerySnapshot<Map<String, dynamic>>> workOrders;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final Post _featuredPost;
  late final List<Event> _upcomingEvents;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _featuredPost = widget.posts.firstWhere(
      (element) => element.featured!,
      orElse: () => widget.posts.first,
    );

    _upcomingEvents = widget.events
        .where(
          (element) => (element.startingTimestamp!.toDate().isAfter(
                    DateTime.now(),
                  ) &&
              element.startingTimestamp!.toDate().isBefore(
                    DateTime.now().add(
                      const Duration(days: 7),
                    ),
                  )),
        )
        .toList();

    _widgetOptions = <Widget>[
      HomeTab(
        name: widget.userData.name!.split(' ')[0],
        featuredPost: _featuredPost,
        upcomingEvents: _upcomingEvents,
      ),
      FeedTab(
        posts: widget.posts,
      ),
      NotifyTab(
        workOrderStream: widget.workOrders,
      ),
      EventsTab(
        events: widget.events,
      ),
      const Text(
        'Index 4: Alerts',
      ),
    ];
  }

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
                      (value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                            settings:
                                const RouteSettings(name: 'WelcomeScreen'),
                          ),
                          (route) => false,
                        );
                      },
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
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) => setState(() => _selectedIndex = value),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.teal[200]!,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper),
                label: 'Feed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.construction),
                label: 'Notify',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Alerts',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
