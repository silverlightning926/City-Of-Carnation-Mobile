import 'package:city_of_carnation/components/news_card.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:flutter/material.dart';

class FeedTab extends StatelessWidget {
  const FeedTab({
    Key? key,
    required this.posts,
  }) : super(key: key);

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: posts.length,
      itemBuilder: ((context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: NewsCard(post: posts[index]),
          )),
    );
  }
}
