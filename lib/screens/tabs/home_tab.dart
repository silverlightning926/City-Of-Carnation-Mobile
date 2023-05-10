import 'dart:ffi';

import 'package:city_of_carnation/serialized/post.dart';
import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    Key? key,
    required this.featuredPost,
  }) : super(key: key);

  final Post featuredPost;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: const [
          Text(
            'Welcome to the City Of Carnation mobile app! We want to make it easier for you to connect with your city. We hope you enjoy the app and find it useful. If you have any questions or feedback, please email us at cityhall@carnationwa.gov.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Featured News:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
