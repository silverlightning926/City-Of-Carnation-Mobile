import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreManager {
  static Future<void> addUserData(
    String uid,
    String name,
    String email,
    String phone,
  ) {
    final user = <String, dynamic>{
      "name": name,
      "email": email,
      "phone": phone,
    };

    return FirebaseFirestore.instance
        .collection("user-info")
        .doc(uid)
        .set(user);
  }

  static Future<UserData> getUserData(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> user =
        await FirebaseFirestore.instance.collection("user-info").doc(uid).get();
    return UserData.fromJson(user.data()!);
  }

  static Future<List<Post>> getPostData() async {
    final QuerySnapshot<Map<String, dynamic>> posts =
        await FirebaseFirestore.instance.collection("post-feed").get();

    return posts.docs.map((e) => Post.fromJson(e.data())).toList();
  }

  static Future<List<Event>> getEventData() async {
    final QuerySnapshot<Map<String, dynamic>> events =
        await FirebaseFirestore.instance.collection("event-info").get();

    return events.docs.map((e) => Event.fromJson(e.data())).toList();
  }
}
