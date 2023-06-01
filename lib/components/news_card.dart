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
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              post.image!,
            ),
            colorFilter: const ColorFilter.mode(
              Color.fromARGB(188, 0, 0, 0),
              BlendMode.darken,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsScreen(
                  post: post,
                ),
                settings: const RouteSettings(name: 'NewsScreen'),
              ),
            );

            AnalyticsService.newsCardClick(
              id: post.id ?? 'No ID',
              title: post.title ?? 'No title',
            );
          },
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
                        post.title!,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.author!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(
                          post.timestamp!.toDate().toLocal(),
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
    );
  }
}
