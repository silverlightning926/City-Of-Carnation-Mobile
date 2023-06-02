import 'package:city_of_carnation/components/mini_event_card.dart';
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.175),
            ),
            child: Text(
              'Welcome to the City Of Carnation mobile app! We want to make it easier for you to connect with your city. We hope you enjoy the app and find it useful. If you have any questions or feedback, please email us at cityhall@carnationwa.gov.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Featured News',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              NewsCard(post: featuredPost),
            ],
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: upcomingEvents.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Upcoming Events',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  height: 275,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => MiniEventCard(
                      event: upcomingEvents[index],
                    ),
                    itemCount: upcomingEvents.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(height: 75),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
