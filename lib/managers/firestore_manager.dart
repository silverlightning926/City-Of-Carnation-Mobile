import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_cache/firestore_cache.dart';

final userInfoRef = FirebaseFirestore.instance.collection('user-info');

final postFeedRef = FirebaseFirestore.instance.collection('post-feed');
final postFeedQuery = postFeedRef.orderBy("timestamp", descending: true);
const postFeedCacheField = "lastUpdated";

final eventInfoRef = FirebaseFirestore.instance.collection('event-info');
final eventInfoQuery =
    eventInfoRef.orderBy("startingTimestamp", descending: false);
const eventInfoCacheField = "lastUpdated";

final workOrdersRef = FirebaseFirestore.instance.collection('work-orders');

final postFeedCacheRef =
    FirebaseFirestore.instance.collection('status').doc('post-feed');
final eventInfoCacheRef =
    FirebaseFirestore.instance.collection('status').doc('event-info');

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

    return userInfoRef.doc(uid).set(user);
  }

  static Future<UserData> getUserData(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> user =
        await userInfoRef.doc(uid).get();

    return UserData.fromJson(user.data()!);
  }

  static Stream<UserData> getUserDataStream(String uid) {
    return userInfoRef
        .doc(uid)
        .snapshots()
        .map((event) => UserData.fromJson(event.data()!));
  }

  static Future<List<Post>> getPostData() async {
    final QuerySnapshot<Map<String, dynamic>> posts =
        await FirestoreCache.getDocuments(
      query: postFeedQuery,
      cacheDocRef: postFeedCacheRef,
      firestoreCacheField: postFeedCacheField,
    );

    return posts.docs
        .map(
          (e) => Post.fromJson(
            id: e.id,
            json: e.data(),
          ),
        )
        .toList();
  }

  static Future<List<Event>> getEventData() async {
    final QuerySnapshot<Map<String, dynamic>> events =
        await FirestoreCache.getDocuments(
      query: eventInfoQuery,
      cacheDocRef: eventInfoCacheRef,
      firestoreCacheField: eventInfoCacheField,
    );

    return events.docs
        .map(
          (e) => Event.fromJson(
            id: e.id,
            json: e.data(),
          ),
        )
        .toList();
  }

  static Future<void> createWorkOrder(String uid, WorkOrder workOrder) {
    return workOrdersRef.doc().set(workOrder.toJson());
  }

  static Future<List<WorkOrder>> getWorkOrders(String uid) async {
    final QuerySnapshot<Map<String, dynamic>> workOrders =
        await workOrdersRef.where("creatorId", isEqualTo: uid).get();

    return workOrders.docs
        .map(
          (e) => WorkOrder.fromJson(
            id: e.id,
            json: e.data(),
          ),
        )
        .toList();
  }

  static Stream<List<WorkOrder>> getWorkOrderStream(String uid) {
    return workOrdersRef.where("creatorId", isEqualTo: uid).snapshots().map(
          (event) => event.docs
              .map((e) => WorkOrder.fromJson(
                    id: e.id,
                    json: e.data(),
                  ))
              .toList(),
        );
  }

  static Future<void> deleteWorkOrder(String workOrderId) {
    return workOrdersRef.doc(workOrderId).delete();
  }
}
