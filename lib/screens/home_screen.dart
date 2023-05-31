import 'package:city_of_carnation/components/avatar/profile_picture.dart';
import 'package:city_of_carnation/screens/profile_screen.dart';
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
              automaticallyImplyLeading: false,
              title: Text(
                [
                  'Welcome ${snapshot.data?.name?.split(' ')[0]}!',
                  'Notify',
                  'Feed',
                  'Events',
                ][_selectedIndex],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Ink(
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              userData: snapshot.data!,
                              userDataStream: widget.userDataStream,
                            ),
                          ),
                        );
                      },
                      child: ProfilePicture(
                        radius: 17,
                        fontsize: 10,
                        name: snapshot.data?.name ?? '',
                        img: snapshot.data!.profilePicture,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                right: 15,
                left: 15,
              ),
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  HomeTab(
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
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) => setState(() => _selectedIndex = value),
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
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
