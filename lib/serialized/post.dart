import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? image;
  bool? featured;
  String? author;
  String? title;
  List<String>? body;
  Timestamp? timestamp;

  Post(
      {this.image,
      this.featured,
      this.author,
      this.title,
      this.body,
      this.timestamp});

  Post.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    featured = json['featured'];
    author = json['author'];
    title = json['title'];
    body = json['body'].cast<String>();
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['featured'] = featured;
    data['author'] = author;
    data['name'] = title;
    data['body'] = body;
    data['timestamp'] = timestamp;
    return data;
  }
}
