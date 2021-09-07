import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/config/paths.dart';
import 'package:instagram/models/notification_model.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

class NotificationRepository extends BaseNotificicationRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotificationRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<Notif>>> getUserNotifications({@required String userId}) {
    return _firebaseFirestore
        .collection(Paths.notifications)
        .doc(userId)
        .collection(Paths.userNotifications)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
            (snap) => snap.docs.map((doc) => Notif.fromDocument(doc)).toList());
  }
}
