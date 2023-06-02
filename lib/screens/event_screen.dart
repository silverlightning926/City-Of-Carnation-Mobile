import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/serialized/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final MapController mapController = MapController();

    return ScaffoldGradientBackground(
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color.fromARGB(255, 37, 7, 128),
          Color(0xFF030417),
          Color(0xFF03040c),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            collapsedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              title: Text(
                event.title!,
                textAlign: TextAlign.left,
              ),
              background: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(1.0),
                      Colors.transparent,
                    ],
                    stops: const [
                      0.0,
                      1.0,
                    ],
                  ).createShader(
                    Rect.fromLTRB(0, 0, rect.width, rect.height),
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: event.image!,
                    color: const Color.fromARGB(188, 0, 0, 0),
                    colorBlendMode: BlendMode.darken,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.175),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'At ${event.locationName}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${DateFormat.yMMMMd().format(event.startingTimestamp!.toDate())} - ${DateFormat.yMMMMd().format(
                                event.endingTimestamp!.toDate().toLocal(),
                              )}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 15),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 250,
                                child: FlutterMap(
                                  mapController: mapController,
                                  options: MapOptions(
                                    center: LatLng(
                                      event.location!.latitude,
                                      event.location!.longitude,
                                    ),
                                    maxBounds: LatLngBounds(
                                      LatLng(
                                        event.location!.latitude - 0.05,
                                        event.location!.longitude - 0.05,
                                      ),
                                      LatLng(
                                        event.location!.latitude + 0.05,
                                        event.location!.longitude + 0.05,
                                      ),
                                    ),
                                    minZoom: 14.0,
                                    maxZoom: 18.0,
                                    zoom: 14.0,
                                    interactiveFlags:
                                        InteractiveFlag.pinchZoom |
                                            InteractiveFlag.drag,
                                  ),
                                  nonRotatedChildren: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  mapController.move(
                                                    LatLng(
                                                      event.location!.latitude,
                                                      event.location!.longitude,
                                                    ),
                                                    14.0,
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.my_location,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  MapsLauncher.launchCoordinates(
                                                      event.location!.latitude,
                                                      event.location!.longitude,
                                                      '${event.locationName}');
                                                },
                                                icon: const Icon(
                                                  Icons.directions,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName:
                                          'com.carnationwa.cityofcarnation',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: LatLng(
                                            event.location!.latitude,
                                            event.location!.longitude,
                                          ),
                                          width: 80,
                                          height: 80,
                                          builder: (context) => const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 50.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      for (String paragraph in event.body!)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Text(
                            paragraph,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
