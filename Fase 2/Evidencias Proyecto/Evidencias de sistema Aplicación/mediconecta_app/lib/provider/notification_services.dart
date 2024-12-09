import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleMedicationReminders(
    String medicationName, int intervalHours, int days) async {
  // Verificar y solicitar el permiso para alarmas exactas en Android 12+
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }

  // Continua programando la notificación si el permiso está concedido
  if (await Permission.scheduleExactAlarm.isGranted) {
    int totalNotifications = (24 ~/ intervalHours) * days;
    DateTime now = DateTime.now();

    for (int i = 0; i < totalNotifications; i++) {
      DateTime notificationTime = now.add(Duration(hours: intervalHours * i));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        'Recordatorio de Medicamento',
        'Es hora de tomar $medicationName',
        tz.TZDateTime.from(notificationTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_channel_id',
            'Recordatorios de Medicamento',
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  } else {
    print("El permiso de alarma exacta no fue concedido.");
  }
}
