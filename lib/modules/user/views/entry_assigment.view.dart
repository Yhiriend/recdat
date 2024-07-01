import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Asegúrate de tener Provider en tus dependencias
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart'; // Ajusta esta ruta según tu estructura

class EntryAssigmentView extends StatefulWidget {
  final String userId; // Recibe el userId
  final List<UserEntryAssignment>?
      initialAssignments; // Lista de asignaciones iniciales (opcional)

  const EntryAssigmentView(
      {super.key, required this.userId, this.initialAssignments});

  @override
  State<EntryAssigmentView> createState() => _EntryAssigmentViewState();
}

class _EntryAssigmentViewState extends State<EntryAssigmentView> {
  late List<UserEntryAssignment> _daysOfWeek;

  @override
  void initState() {
    super.initState();
    _initializeAssignments();
  }

  void _initializeAssignments() {
    // Inicializa la lista con los valores predeterminados si initialAssignments es null o vacío
    if (widget.initialAssignments == null ||
        widget.initialAssignments!.isEmpty) {
      _daysOfWeek = [
        UserEntryAssignment(day: "Monday"),
        UserEntryAssignment(day: "Tuesday"),
        UserEntryAssignment(day: "Wednesday"),
        UserEntryAssignment(day: "Thursday"),
        UserEntryAssignment(day: "Friday"),
        UserEntryAssignment(day: "Saturday"),
        UserEntryAssignment(day: "Sunday"),
      ];
    } else {
      _daysOfWeek = widget.initialAssignments!;
    }
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _daysOfWeek[index].setHour(picked.format(context));
      });
    }
  }

  void _clearTime(int index) {
    setState(() {
      _daysOfWeek[index].clearHour();
    });
  }

  void _saveAssignments() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.assignEntry(context, widget.userId, _daysOfWeek);

    // Puedes mostrar un mensaje de éxito o navegar a otra pantalla si es necesario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Asignaciones guardadas exitosamente!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment entry'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('Day')),
                DataColumn(label: Text('Hour')),
                DataColumn(label: Text('Action')),
              ],
              rows: _daysOfWeek.asMap().entries.map((entry) {
                int index = entry.key;
                UserEntryAssignment dayEntry = entry.value;
                return DataRow(
                  cells: [
                    DataCell(Text(dayEntry.day)),
                    DataCell(
                      InkWell(
                        onTap: () => _selectTime(context, index),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            hintText: "Select hour",
                            border: InputBorder.none,
                          ),
                          child: Text(
                            dayEntry.hour.isEmpty
                                ? "Select hour"
                                : dayEntry.hour,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      ElevatedButton(
                        onPressed: () => _clearTime(index),
                        child: const Text("Limpiar"),
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
                  _saveAssignments();
                },
                text: "Guardar cambios",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
