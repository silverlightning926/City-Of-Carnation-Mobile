import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.post});

  final Post post;

  Color stringToColor(String seed) {
    int hash = 0;
    for (int i = 0; i < seed.length; i++) {
      hash = seed.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final int finalHash = hash.abs() % (1 << 32);
    final double hue = finalHash / (1 << 32);
    return HSVColor.fromAHSV(1.0, hue * 360, 0.9, 0.60).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            collapsedHeight: 125.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              title: Text(
                post.title!,
                textAlign: TextAlign.left,
              ),
              background: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: post.image!,
                  color: const Color.fromARGB(188, 0, 0, 0),
                  colorBlendMode: BlendMode.darken,
                  fit: BoxFit.cover,
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
                              'By ${post.author}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'On ${DateFormat.yMMMMd().format(post.timestamp!.toDate())}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: [
                          for (String tag in post.tags!)
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: stringToColor(tag),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(tag),
                            ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      for (String paragraph in post.body!)
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
          )
        ],
      ),
    );
  }
}
