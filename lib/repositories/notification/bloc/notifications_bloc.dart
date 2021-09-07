import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram/blocs/blocs.dart';
import 'package:instagram/models/failure_model.dart';
import 'package:instagram/models/notification_model.dart';
import 'package:instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Notif>>> _subscription;

  NotificationsBloc(
      {@required NotificationRepository notificationRepository,
      @required AuthBloc authBloc})
      : _notificationRepository = notificationRepository,
        _authBloc = authBloc,
        super(NotificationsState.initial()) {
    _subscription?.cancel();
    _subscription = _notificationRepository
        .getUserNotifications(userId: _authBloc.state.user.uid)
        .listen((notification) async {
      final allNotifications = await Future.wait(notification);
      add(NotificationsUpdateNotifications(notifications: allNotifications));
    });
  }

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is NotificationsUpdateNotifications) {
      yield* _mapNotificationsUpdateNotificationsToState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Stream<NotificationsState> _mapNotificationsUpdateNotificationsToState(
      NotificationsUpdateNotifications event) async* {
    yield state.copyWith(
        status: NotificationStatus.loaded, notifications: event.notifications);
  }
}
