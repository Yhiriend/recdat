import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/utils/local_notifications.dart';
import 'package:recdat/utils/permissions_request.dart';
import 'package:recdat/utils/utils.dart';
import 'package:recdat/views/home.view.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TeacherNotificationsView extends StatefulWidget {
  const TeacherNotificationsView({Key? key});

  @override
  State<TeacherNotificationsView> createState() =>
      _TeacherNotificationsViewState();
}

class _TeacherNotificationsViewState extends State<TeacherNotificationsView> {
  late List<UserEntryAssignment> _daysOfWeekState = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listenToNotifications();
      _initializeAssignments();
      //scheduleNotifications();
      //requestNotificationPermissions();
    });
  }

  void _initializeAssignments() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.syncUserDataByUid(context);

    final user = authProvider.user;
    // Inicializa la lista con los valores predeterminados si initialAssignments es null o vacío
    var _daysOfWeek = [
      UserEntryAssignment(day: "Monday"),
      UserEntryAssignment(day: "Tuesday"),
      UserEntryAssignment(day: "Wednesday"),
      UserEntryAssignment(day: "Thursday"),
      UserEntryAssignment(day: "Friday"),
      UserEntryAssignment(day: "Saturday"),
      UserEntryAssignment(day: "Sunday"),
    ];

    setState(() {
      _daysOfWeekState = _daysOfWeek;
    });

    // Actualiza los valores de _daysOfWeek si el usuario tiene entryAssignments definido
    if (user != null && user.entryAssigments != null) {
      _daysOfWeek.forEach((day) {
        final assignment = user.entryAssigments!.firstWhere(
          (assignment) => assignment.day == day.day,
          orElse: () => UserEntryAssignment(day: day.day, hour: ""),
        );
        day.hour = assignment.hour;
      });

      setState(() {
        _daysOfWeekState = _daysOfWeek;
      });
    }
  }

  void listenToNotifications() {
    print("listening to notifications...");
    LocalNotifications.onClickNotification.stream.listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    });
  }

  void scheduleNotifications() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    tz.initializeTimeZones();

    if (user != null && user.entryAssigments != null) {
      final now = tz.TZDateTime.now(tz.getLocation('America/Bogota'));
      print("NOW $now");
      _daysOfWeekState.forEach((day) {
        final assignment = user.entryAssigments!.firstWhere(
          (assignment) => assignment.day == day.day,
          orElse: () => UserEntryAssignment(day: day.day, hour: ""),
        );

        if (assignment.hour.isNotEmpty) {
          // Parsea la hora del string a TimeOfDay
          final parts = assignment.hour.split(":");
          var hour = int.parse(parts[0]);
          final minute = int.parse(parts[1].split(" ")[0]);
          final period = parts[1].split(" ")[1];

          // Ajusta la hora para el formato AM/PM
          if (period == "PM" && hour != 12) {
            hour += 12;
          } else if (period == "AM" && hour == 12) {
            hour = 0;
          }

          // Crea el DateTime programado en la zona horaria de Colombia
          final scheduledDateTime = tz.TZDateTime(
            tz.getLocation('America/Bogota'),
            now.year,
            now.month,
            now.day,
            hour,
            (minute + 3),
          );
          print("SCHEDULED $scheduledDateTime");
          // Verifica si la fecha es la misma y la hora programada es mayor
          if (scheduledDateTime.year == now.year &&
              scheduledDateTime.month == now.month &&
              scheduledDateTime.day == now.day &&
              scheduledDateTime.hour > now.hour) {
            // Programa la notificación si la hora programada es mayor a la actual

            print("HAS BEEN PROGRAMED");
            LocalNotifications.showScheduledNotification(
              title: "Registro Pendiente",
              body:
                  "Recuerda que debes registrarte en la institución antes de ${assignment.hour}",
              payload: "",
              scheduledDate: scheduledDateTime,
            );
          } else if (scheduledDateTime.isAfter(now)) {
            LocalNotifications.cancelAll();

            LocalNotifications.showScheduledNotification(
              title: "Registro Pendiente",
              body:
                  "Recuerda que debes registrarte en la institución antes de ${assignment.hour}",
              payload: "",
              scheduledDate: scheduledDateTime,
            );
          }
        }
      });
    }
  }

  void refreshSchedule() {
    setState(() {
      _initializeAssignments(); // Vuelve a inicializar los horarios
      scheduleNotifications(); // Vuelve a programar las notificaciones
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario de Entrada'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Day')),
                    DataColumn(label: Text('Hour')),
                  ],
                  rows: _daysOfWeekState.asMap().entries.map((entry) {
                    int index = entry.key;
                    UserEntryAssignment dayEntry = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text(dayEntry.day)),
                        DataCell(
                          InputDecorator(
                            decoration: const InputDecoration(
                              hintText: "Select hour",
                              border: InputBorder.none,
                            ),
                            child: Text(
                              dayEntry.hour.isEmpty
                                  ? "No assigned"
                                  : dayEntry.hour,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RecdatButtonAsync(
                    onPressed: () async {
                      await Future.delayed(const Duration(seconds: 3));
                      refreshSchedule();
                      showSnackBar(
                          context, "Tabla sincronizada", SnackBarType.success);
                    },
                    color: "success",
                    text: "Actualizar tabla",
                  ),
                ),
                /*const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RecdatButtonAsync(
                    onPressed: () async {
                      await Future.delayed(const Duration(seconds: 3));
                      DateTime scheduledate =
                          DateTime.now().add(const Duration(seconds: 20));
                      LocalNotifications.showPeriodicNotifications(
                          title: "SIMPLE", body: "body", payload: "payload");
                      LocalNotifications.showScheduledNotification(
                          title: "Scheduled",
                          body: "programada esta cosa",
                          payload: "",
                          scheduledDate: scheduledate);
                      print("PROGRAMADA LA NOTIFICACO $scheduledate");
                      showSnackBar(context, "Notificaciones sincronizadas",
                          SnackBarType.success);
                    },
                    text: "Sincronizar notificaciones",
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
