import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/screens/news_screen.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

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
              FirebaseAnalytics.instance.logEvent(
                name: 'news_card_tapped',
                parameters: <String, dynamic>{
                  'id': post.id!,
                  'title': post.title!,
                },
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsScreen(
                    post: post,
                  ),
                  settings: const RouteSettings(name: 'NewsScreen'),
                ),
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
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.author!,
                          style: Theme.of(context).textTheme.subtitle1,
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
