import 'package:city_of_carnation/screens/settings_screen.dart';
import 'package:city_of_carnation/screens/tabs/events_tab.dart';
import 'package:city_of_carnation/screens/tabs/feed_tab.dart';
import 'package:city_of_carnation/screens/tabs/home_tab.dart';
import 'package:city_of_carnation/screens/tabs/notify_tab.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userData,
    required this.userDataStream,
    required this.posts,
    required this.events,
    required this.workOrders,
    required this.workOrderStream,
  });

  final UserData userData;
  final Stream<UserData> userDataStream;
  final List<Post> posts;
  final List<Event> events;
  final List<WorkOrder> workOrders;
  final Stream<List<WorkOrder>> workOrderStream;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final Post _featuredPost;
  late final List<Event> _upcomingEvents;

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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.userDataStream,
      initialData: widget.userData,
      builder: (context, snapshot) => WillPopScope(
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
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          userData: snapshot.data!,
                          userDataStream: widget.userDataStream,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                HomeTab(
                  name: snapshot.data!.name?.split(' ')[0] ?? '',
                  featuredPost: _featuredPost,
                  upcomingEvents: _upcomingEvents,
                ),
                NotifyTab(
                  workOrders: widget.workOrders,
                  workOrderStream: widget.workOrderStream,
                ),
                FeedTab(
                  posts: widget.posts,
                ),
                EventsTab(
                  events: widget.events,
                ),
              ],
            ),
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
                  icon: Icon(Icons.construction),
                  label: 'Notify',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'Events',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
