import 'package:instagram/models/models.dart';

abstract class BaseNotificicationRepository {
  Stream<List<Future<Notif>>> getUserNotifications({String userId});
}
