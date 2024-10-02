import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconecta_app/notificacion_controller.dart';
import 'package:mediconecta_app/widgets/button_home.dart';
import 'package:mediconecta_app/widgets/urgent_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    //Ejecuta las notificaciones desde el inicio del componente
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionRececeivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreateMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceiveMethod,
    );

    // Programar las notificaciones
    NotificationController.scheduleDailyNotification(1, 'Recordatorio de Medicación', 'Es hora de tomar Paracetamol', DateTime.now().hour, DateTime.now().minute + 1);
    NotificationController.scheduleDailyNotification(2, 'Recordatorio de Medicación', 'Es hora de tomar tu medicamento de las 12', DateTime.now().hour, DateTime.now().minute + 1);
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            ImportantBanner(
              message: 'Recuerda que a las 8 te corresponde el paracetamol.',
              icon: Icons.alarm,
              backgroundColor: Colors.red[100]!,
              textColor: Colors.red,
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonHomeWidget(
                  title: 'Reserva tú hora médica',
                  icon: Icons.medical_services_outlined,
                  action: () {
                    context.push('/assistant');
                  },
                ),
                const SizedBox(height: 20,),
                ButtonHomeWidget(
                  title: 'Ver citas pendientes',
                  icon: Icons.assignment,
                  action: () {
                    context.push('/pendingAppointments');
                  },
                ),
                const SizedBox(height: 20,),
                ButtonHomeWidget(
                  title: 'Registro de salud',
                  icon: Icons.save_as_outlined,
                  action: () {
                    context.push('/healthRecord');
                  },
                ),
                const SizedBox(height: 20,),
                ButtonHomeWidget(
                  title: 'Calendario de medicamentos',
                  icon: Icons.calendar_month,
                  action: () {
                    context.push('/healthRecord');
                  },
                ),
              ],
            ),

            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
              ],
            ),
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 3,
              channelKey: "basic_channel",
              title: "Prueba de Notificación",
              body: "¡Notificación instantánea!",
            ),
          );
        },
        child: const Icon(Icons.notification_add),
      ),
    );
  }
}
