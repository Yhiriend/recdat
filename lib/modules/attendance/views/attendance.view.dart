import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/attendance/model/attendance.model.dart';
import 'package:recdat/modules/attendance/widgets/card_attendance.widget.dart';
import 'package:recdat/modules/attendance/widgets/modal_create_attendance.widget.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_input_date.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  final List<ValueNotifier<bool>> _isDeletedNotifiers = [];
  late TextEditingController _filterStartDateController;
  late TextEditingController _filterEndDateController;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  List<Attendance>?
      _filteredAttendances; // Inicialización directa en initState()

  @override
  void initState() {
    super.initState();
    _filterStartDateController = TextEditingController();
    _filterEndDateController = TextEditingController();

    // Inicialización de fechas con la fecha actual
    _filterStartDate = DateTime.now();

    // Inicialización de _filterEndDate a las 23:59 del día actual
    _filterEndDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
    );

    // Inicializar _filteredAttendances con todas las asistencias del usuario
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      _filteredAttendances =
          List<Attendance>.from(authProvider.user!.attendances!);
    }

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _filterAttendancesByDate());
  }

  @override
  void dispose() {
    for (var notifier in _isDeletedNotifiers) {
      notifier.dispose();
    }
    _filterStartDateController.dispose();
    _filterEndDateController.dispose();
    super.dispose();
  }

  Future<void> _filterAttendancesByDate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.user == null) return;
    await authProvider.syncUserDataByUid(context);
    // Ajustar _filterEndDate a las 23:59 horas del mismo día
    DateTime adjustedEndDate = DateTime(
      _filterEndDate!.year,
      _filterEndDate!.month,
      _filterEndDate!.day,
      23,
      59,
      59,
    );

    List<Attendance> filteredAttendances;

    if (_filterStartDate != null && _filterEndDate != null) {
      filteredAttendances = authProvider.user!.attendances!.where((attendance) {
        final createdAt = DateTime.parse(attendance.createdAt!);
        return createdAt.isAfter(_filterStartDate!) &&
            createdAt.isBefore(adjustedEndDate);
      }).toList();
    } else {
      // Si no hay fechas seleccionadas, mostrar todas las asistencias
      filteredAttendances = authProvider.user!.attendances!;
    }

    setState(() {
      _filteredAttendances = filteredAttendances;
    });
  }

  Future<void> _updateFilteredAttendances() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.user == null) return;

    await authProvider.syncUserDataByUid(context);
    // Filtrar asistencias de la fecha actual
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay =
        DateTime(today.year, today.month, today.day, 23, 59, 59);

    List<Attendance> filteredAttendances =
        authProvider.user!.attendances!.where((attendance) {
      final createdAt = DateTime.parse(attendance.createdAt!);
      return createdAt.isAfter(startOfDay) && createdAt.isBefore(endOfDay);
    }).toList();

    setState(() {
      _filteredAttendances = filteredAttendances;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: authProvider.isLoading
          ? RecdatStyles.backgroundLoader
          : RecdatStyles.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(115, 0, 0, 0),
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Desde",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Expanded(
                      child: RecdatInputDate(
                        placeholder: "Fecha",
                        controller: _filterStartDateController,
                        onChanged: (date) {
                          setState(() {
                            _filterStartDate = date;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    const Text(
                      "Hasta",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Expanded(
                      child: RecdatInputDate(
                        placeholder: "Fecha",
                        controller: _filterEndDateController,
                        onChanged: (date) {
                          setState(() {
                            _filterEndDate = date;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _filterAttendancesByDate,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: RecdatStyles.whiteColor,
                    ));
                  }

                  if (_filteredAttendances == null ||
                      _filteredAttendances!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.rule_folder_rounded,
                              color: RecdatStyles.defaultColor,
                              size: 150,
                            ),
                            Text(
                                "Selecciona una fecha de inicio y una fecha final para filtrar la busqueda de las assistencias e inasistensias realizadas en el intervalo de esas fechas"),
                          ],
                        ),
                      ),
                    );
                  }

                  if (authProvider.user == null) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                RecdatStyles.darkTextColor, BlendMode.srcIn),
                            child: Icon(Icons.block),
                          ),
                          const Text(
                            "Tu usuario esta desincronizado",
                            style: TextStyle(
                                color: RecdatStyles.darkTextColor,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: _filteredAttendances!.length,
                    itemBuilder: (context, index) {
                      final attendance = _filteredAttendances![index];
                      final isDeletedNotifier = ValueNotifier<bool>(false);
                      _isDeletedNotifiers.add(isDeletedNotifier);
                      return ValueListenableBuilder<bool>(
                        valueListenable: isDeletedNotifier,
                        builder: (context, isDeleted, child) {
                          if (isDeleted) {
                            return SizedBox(); // Widget vacío si se ha eliminado
                          }
                          return CardAttendanceWidget(
                            key: UniqueKey(),
                            isAttendance: attendance.type == "ATTENDANCE",
                            attendance: attendance,
                            userUUID: authProvider.user!.uid ?? "",
                            isDeletedNotifier: isDeletedNotifier,
                            onDelete: () {
                              print("on delte press");
                              _updateFilteredAttendances();
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        backgroundColor: RecdatStyles.blueDarkColor,
        foregroundColor: RecdatStyles.defaultTextColor,
        overlayColor: RecdatStyles.blueDarkColor,
        overlayOpacity: 0.4,
        spacing: 8,
        onPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ModalCreateAttendanceWidget(
                onClose: () {
                  _updateFilteredAttendances();
                },
              );
            },
          ).then((_) {
            _updateFilteredAttendances();
          });
        },
      ),
    );
  }
}
