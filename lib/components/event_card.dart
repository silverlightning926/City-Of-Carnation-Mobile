import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/screens/event_screen.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AnalyticsService.logEvent(
          name: 'event_card_tapped',
          parameters: {
            'event_id': event.id,
          },
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventScreen(
              event: event,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.175),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: ShaderMask(
                blendMode: BlendMode.dstATop,
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(1.0),
                      Colors.white.withOpacity(0.75),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ).createShader(
                    Rect.fromLTRB(0, 0, rect.width, rect.height),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: event.image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat.yMMMMd()
                        .format(event.startingTimestamp!.toDate()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
