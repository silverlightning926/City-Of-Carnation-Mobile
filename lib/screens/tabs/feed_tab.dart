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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: posts.map((post) => NewsCard(post: post)).toList(),
      ),
    );
  }
}
