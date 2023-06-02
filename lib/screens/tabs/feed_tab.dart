import 'package:city_of_carnation/components/news_card.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedTab extends StatelessWidget {
  const FeedTab({
    Key? key,
    required this.posts,
  }) : super(key: key);

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          for (var monthYear in groupPostsByMonth().keys)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMM().format(monthYear),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                for (var post in groupPostsByMonth()[monthYear]!)
                  NewsCard(post: post),
                const SizedBox(height: 20),
              ],
            ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }

  Map<DateTime, List<Post>> groupPostsByMonth() {
    Map<DateTime, List<Post>> groupedPosts = {};

    for (var post in posts) {
      DateTime monthYear = DateTime(
        post.timestamp!.toDate().year,
        post.timestamp!.toDate().month,
      );

      if (groupedPosts.containsKey(monthYear)) {
        groupedPosts[monthYear]!.add(post);
      } else {
        groupedPosts[monthYear] = [post];
      }
    }

    return groupedPosts;
  }
}
