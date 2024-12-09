import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconecta_app/api/apiService.dart';
import 'package:mediconecta_app/provider/notification_services.dart';
import 'package:mediconecta_app/provider/user_auth_provider.dart';
import 'package:mediconecta_app/widgets/button_home.dart';
import 'package:mediconecta_app/widgets/urgent_banner_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _currentUser;

  List<dynamic> recordatorios = [];

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    configurarRecordatorio();

    // //Ejecuta las notificaciones desde el inicio del componente
    // AwesomeNotifications().setListeners(
    //   onActionReceivedMethod: NotificationController.onActionRececeivedMethod,
    //   onNotificationCreatedMethod: NotificationController.onNotificationCreateMethod,
    //   onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    //   onDismissActionReceivedMethod: NotificationController.onDismissActionReceiveMethod,
    // );

    // // Programar las notificaciones
    // NotificationController.scheduleDailyNotification(1, 'Recordatorio de Medicación', 'Es hora de tomar Paracetamol', DateTime.now().hour, DateTime.now().minute + 1);
    // NotificationController.scheduleDailyNotification(2, 'Recordatorio de Medicación', 'Es hora de tomar tu medicamento de las 12', DateTime.now().hour, DateTime.now().minute + 1);

    // Ejecuta la inicialización del usuario después del primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCurrentUser();
    });
  }

  void _initializeCurrentUser() {
    try {
      final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
      final currentUser = userAuthProvider.currentUser;

      setState(() {
        _currentUser = currentUser!;
      });

      configurarRecordatorio();

    } catch (e) {
      print('Error al inicializar user $e');
    }
  }
  
  void configurarRecordatorio() async {

    // Llamar a la función de creación del registro de salud
    final response = await apiService.getRecordatorios();

    setState(() {
        recordatorios = response; // Asigna la lista de citas
    });

    print('respuesta recordatorios: $response');

    // Ejemplo: Paracetamol cada 8 horas durante 5 días
    scheduleMedicationReminders("Paracetamol", 8, 5);
    scheduleMedicationReminders("Metamizol", 1, 10);
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              children: recordatorios.map((elemento) {
                print('elemento $elemento');
                return ImportantBanner(
                  message: "Es hora de tomar ${elemento['desc_medicamento']}",
                  icon: Icons.alarm,
                  backgroundColor: Colors.red[100]!,
                  textColor: Colors.red,
                );
              }).toList(), // Convierte el iterable de `map` en una lista de widgets
            ),
            // ImportantBanner(
            //   message: 'Recuerda que a las 8 te corresponde el paracetamol.',
            //   icon: Icons.alarm,
            //   backgroundColor: Colors.red[100]!,
            //   textColor: Colors.red,
            // ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonHomeWidget(
                  title: 'Reserva tú hora médica',
                  icon: Icons.medical_services_outlined,
                  action: () {
                    if (_currentUser != null) { // Verifica que _currentUser no sea nulo
                      context.push('/assistant', extra: _currentUser);
                    } else {
                      // Manejar el caso donde _currentUser es nulo
                      // Podrías mostrar un mensaje al usuario o redirigirlo a una pantalla de login
                      print('El usuario actual es nulo.'); // O cualquier lógica que prefieras
                    }
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
                    context.push('/medicalSchedule');
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     AwesomeNotifications().createNotification(
      //       content: NotificationContent(
      //         id: 3,
      //         channelKey: "basic_channel",
      //         title: "Prueba de Notificación",
      //         body: "¡Notificación instantánea!",
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.notification_add),
      // ),
    );
  }
}
