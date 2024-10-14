import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreateMethod(
    ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceiveMethod(
    ReceivedAction receivedAction) async {}

  @pragma("vm:entry-point")
  static Future<void> onActionRececeivedMethod(
    ReceivedAction receivedAction) async {}


  // Método para programar una notificación diaria
  static Future<void> scheduleDailyNotification(int id, String title, String body, int hour, int minute) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,  // Esto hace que la notificación se repita diariamente a la misma hora
      ),
    );
  }
}