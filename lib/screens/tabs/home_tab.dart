import 'package:city_of_carnation/components/event_card.dart';
import 'package:city_of_carnation/components/news_card.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    Key? key,
    required this.featuredPost,
    required this.upcomingEvents,
  }) : super(key: key);

  final Post featuredPost;
  final List<Event> upcomingEvents;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[900],
              ),
              child: const Text(
                'Welcome to the City Of Carnation mobile app! We want to make it easier for you to connect with your city. We hope you enjoy the app and find it useful. If you have any questions or feedback, please email us at cityhall@carnationwa.gov.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Featured News',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          NewsCard(post: featuredPost),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Upcoming Events',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
                itemBuilder: (context, index) => EventCard(
                      event: upcomingEvents[index],
                    ),
                itemCount: upcomingEvents.length,
                scrollDirection: Axis.horizontal),
          ),
        ],
      ),
    );
  }
}
