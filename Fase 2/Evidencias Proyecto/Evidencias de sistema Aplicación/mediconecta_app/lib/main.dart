import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Para localización
import 'package:mediconecta_app/provider/user_auth_provider.dart';
import 'package:mediconecta_app/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la zona horaria
  tz.initializeTimeZones();

  // Configuración inicial para `flutter_local_notifications`
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // await AwesomeNotifications().initialize(
  //   null,
  //   [
  //     NotificationChannel(
  //       channelGroupKey: "basic_channel_group",
  //       channelKey: "basic_channel",
  //       channelName: "Basic Notification",
  //       channelDescription: "Basic notifications channel",
  //     )
  //   ],
  //   channelGroups: [
  //     NotificationChannelGroup(
  //       channelGroupKey: "basic_channel_group",
  //       channelGroupName: "Basic Group",
  //     )
  //   ]
  // );
  // bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
  // if(!isAllowedToSendNotification) {
  //   AwesomeNotifications().requestPermissionToSendNotifications();
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuthProvider()..tryAutoLogin()),
      ],
      child: MaterialApp.router(
        locale: const Locale('es', ''), // Establece el idioma a español
        supportedLocales: const [
          Locale('es', ''), // Añadir español como idioma soportado
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}