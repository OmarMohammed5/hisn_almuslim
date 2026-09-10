import 'notification_service.dart';

class NotificationHealthChecker {
  NotificationHealthChecker._();

  static final instance = NotificationHealthChecker._();

  Future<NotificationHealth> check() {
    return NotificationService.service.health();
  }

  Future<bool> isReadyForExactScheduling() async {
    final health = await check();
    return health.readyForExactScheduling;
  }
}
