import 'package:city_of_carnation/components/event_card.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  State<EventsTab> createState() => _EventsTabState();

  final List<Event> events;
}

class _EventsTabState extends State<EventsTab> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            'Events',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedMonth = selectedMonth - 1;
                    if (selectedMonth == 0) {
                      selectedMonth = 12;
                      selectedYear = selectedYear - 1;
                    }
                  });
                },
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.chevron_left,
                  size: 40,
                ),
              ),
              SizedBox(
                width: 200,
                child: Ink(
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        DateFormat('MMMM yyyy').format(
                          DateTime(selectedYear, selectedMonth),
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    onLongPress: () {
                      setState(() {
                        selectedMonth = DateTime.now().month;
                        selectedYear = DateTime.now().year;
                      });
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedMonth = selectedMonth + 1;
                    if (selectedMonth == 13) {
                      selectedMonth = 1;
                      selectedYear = selectedYear + 1;
                    }
                  });
                },
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.chevron_right,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: widget.events.length,
            itemBuilder: ((context, index) {
              if (widget.events[index].startingTimestamp!.toDate().month ==
                      selectedMonth &&
                  widget.events[index].startingTimestamp!.toDate().year ==
                      selectedYear) {
                return EventCard(event: widget.events[index]);
              } else {
                return const SizedBox();
              }
            }),
          ),
        )
      ],
    );
  }
}
