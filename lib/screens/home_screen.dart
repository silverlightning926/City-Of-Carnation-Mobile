import 'package:city_of_carnation/screens/welcome_screen.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userData});

  final UserData userData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Text(
      'Index 0: Home',
    ),
    const Text(
      'Index 1: Feed',
    ),
    const Text(
      'Index 2: Notify',
    ),
    const Text(
      'Index 3: Alerts',
    ),
  ];

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
                          (value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeScreen(),
                              ),
                              (route) => false),
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
          body: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Text(
                    'Hello ${widget.userData.name!.split(' ')[0]}!',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                _widgetOptions.elementAt(_selectedIndex),
              ],
            ),
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
                icon: Icon(Icons.newspaper),
                label: 'Feed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.construction),
                label: 'Notify',
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
