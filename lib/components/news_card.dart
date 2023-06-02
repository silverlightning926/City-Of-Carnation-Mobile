import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/screens/news_screen.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AnalyticsService.logEvent(
          name: 'news_card_tapped',
          parameters: {
            'post_id': post.id,
          },
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NewsScreen(
              post: post,
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
                  imageUrl: post.image!,
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
                    post.title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'On ${DateFormat.yMMMMd().format(post.timestamp!.toDate())}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'By ${post.author}',
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
