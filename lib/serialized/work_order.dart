import 'package:cloud_firestore/cloud_firestore.dart';

class WorkOrder {
  String? id;
  String? title;
  String? description;
  GeoPoint? location;
  Timestamp? timestamp;
  String? status;
  String? priority;
  List<String>? images;

  WorkOrder({
    this.id,
    this.title,
    this.description,
    this.location,
    this.timestamp,
    this.status,
    this.priority,
    this.images,
  });

  WorkOrder.fromJson({required this.id, required Map<String, dynamic> json}) {
    id = id;
    title = json['title'];
    description = json['description'];
    location = json['location'];
    timestamp = json['timestamp'];
    status = json['status'];
    priority = json['priority'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['location'] = location;
    data['timestamp'] = timestamp;
    data['status'] = status;
    data['priority'] = priority;
    data['images'] = images;
    return data;
  }
}
