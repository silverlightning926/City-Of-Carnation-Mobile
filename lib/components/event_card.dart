import 'package:city_of_carnation/serialized/event.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Ink(
        width: 250,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.dstATop,
            ),
            fit: BoxFit.cover,
            image: NetworkImage(event.image!),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {},
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
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.locationName!,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.startingTimestamp!.toDate().toLocal().toString(),
                        style: Theme.of(context).textTheme.subtitle2,
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
    );
  }
}
