import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? image;
  String? title;
  List<String>? body;
  String? locationName;
  GeoPoint? location;
  Timestamp? startingTimestamp;
  Timestamp? endingTimestamp;
  String? repeat;

  Event({
    this.image,
    this.title,
    this.body,
    this.location,
    this.locationName,
    this.startingTimestamp,
    this.endingTimestamp,
    this.repeat,
  });

  Event.fromJson(Map<String, dynamic> json) {
    image = json['imageURL'];
    title = json['title'];
    body = json['body'].cast<String>();
    location = json['location'];
    locationName = json['locationName'];
    startingTimestamp = json['startingTimestamp'];
    endingTimestamp = json['endingTimestamp'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = title;
    data['body'] = body;
    data['location'] = location;
    data['locationName'] = locationName;
    data['startingTimestamp'] = startingTimestamp;
    data['endingTimestamp'] = endingTimestamp;
    data['repeat'] = repeat;
    return data;
  }
}
