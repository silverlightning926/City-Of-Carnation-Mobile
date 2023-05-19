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
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Feed',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: ((context, index) => NewsCard(post: posts[index])),
            ),
          ),
        ],
      ),
    );
  }
}
