import 'package:cloud_firestore/cloud_firestore.dart';

class WorkOrder {
  String? id;
  String? title;
  String? description;
  String? location;
  Timestamp? timestamp;
  String? status;
  int? priority;
  String? image;
  bool? isCompleted;

  WorkOrder({
    this.id,
    this.title,
    this.description,
    this.location,
    this.timestamp,
    this.status,
    this.priority,
    this.image,
    this.isCompleted,
  });

  WorkOrder.fromJson({required this.id, required Map<String, dynamic> json}) {
    id = id;
    title = json['title'];
    description = json['description'];
    location = json['location'];
    timestamp = json['timestamp'];
    status = json['status'];
    priority = json['priority'];
    image = json['images'].cast<String>();
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['location'] = location;
    data['timestamp'] = timestamp;
    data['status'] = status;
    data['priority'] = priority;
    data['images'] = image;
    data['isCompleted'] = isCompleted;
    return data;
  }
}