import 'package:city_of_carnation/serialized/event.dart';
import 'package:city_of_carnation/serialized/post.dart';
import 'package:city_of_carnation/serialized/user_data.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_cache/firestore_cache.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final CollectionReference<Map<String, dynamic>> _userInfoRef =
      _firestore.collection('user-info');

  static final CollectionReference<Map<String, dynamic>> _postFeedRef =
      _firestore.collection('post-feed');

  static final CollectionReference<Map<String, dynamic>> _eventInfoRef =
      _firestore.collection('event-info');

  static final CollectionReference<Map<String, dynamic>> _workOrderRef =
      _firestore.collection('work-orders');

  static final DocumentReference<Map<String, dynamic>> _postFeedCacheRef =
      _firestore.collection('status').doc('post-feed');

  static const String postFeedCacheField = 'lastUpdated';

  static final DocumentReference<Map<String, dynamic>> _eventInfoCacheRef =
      _firestore.collection('status').doc('event-info');

  static const String _eventInfoCacheField = 'lastUpdated';

  static final Query<Map<String, dynamic>> _postFeedQuery =
      _postFeedRef.orderBy('timestamp', descending: true);

  static final Query<Map<String, dynamic>> _eventInfoQuery =
      _eventInfoRef.orderBy('startingTimestamp', descending: true);

  static final Query<Map<String, dynamic>> _workOrderQuery =
      _workOrderRef.orderBy('timestamp', descending: true);

  static Future<void> addUserData(
    String uid,
    UserData userData,
  ) async {
    return await _userInfoRef.doc(uid).set(userData.toJson());
  }

  static Future<UserData> getUserData(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> user =
        await _userInfoRef.doc(uid).get();

    return UserData.fromJson(user.data()!);
  }

  static Stream<UserData> getUserDataStream(String uid) {
    return _userInfoRef
        .doc(uid)
        .snapshots()
        .map((event) => UserData.fromJson(event.data()!));
  }

  static Future<void> updateUserData(
    String uid,
    UserData userData,
  ) async {
    return await _userInfoRef.doc(uid).update(userData.toJson());
  }

  static Future<List<Post>> getPostData() async {
    final QuerySnapshot<Map<String, dynamic>> posts =
        await FirestoreCache.getDocuments(
      query: _postFeedQuery,
      cacheDocRef: _postFeedCacheRef,
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
      query: _eventInfoQuery,
      cacheDocRef: _eventInfoCacheRef,
      firestoreCacheField: _eventInfoCacheField,
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

  static Future<void> createWorkOrder(String uid, WorkOrder workOrder) async {
    return await _workOrderRef.doc().set(workOrder.toJson());
  }

  static Future<List<WorkOrder>> getWorkOrders() async {
    final QuerySnapshot<Map<String, dynamic>> workOrders = await _workOrderQuery
        .where(
          'creatorId',
          isEqualTo: AuthService.userId,
        )
        .get();

    return workOrders.docs
        .map(
          (e) => WorkOrder.fromJson(
            id: e.id,
            json: e.data(),
          ),
        )
        .toList();
  }

  static Stream<List<WorkOrder>> getWorkOrderStream() {
    return _workOrderQuery
        .where(
          'creatorId',
          isEqualTo: AuthService.userId,
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => WorkOrder.fromJson(
                  id: e.id,
                  json: e.data(),
                ),
              )
              .toList(),
        );
  }

  static Future<void> deleteWorkOrder(String workOrderId) async {
    return await _workOrderRef.doc(workOrderId).delete();
  }
}
