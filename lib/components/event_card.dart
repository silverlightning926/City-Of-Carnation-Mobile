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
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(188, 0, 0, 0),
                BlendMode.darken,
              ),
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                event.image!,
              ),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventScreen(
                    event: event,
                  ),
                  settings: const RouteSettings(name: 'EventScreen'),
                ),
              );

              AnalyticsService.logEventCardClick(
                id: event.id ?? 'No ID',
                title: event.title ?? 'No Title',
              );
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          event.title!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.locationName!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat.yMMMMd().format(
                            event.startingTimestamp!.toDate().toLocal(),
                          ),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
