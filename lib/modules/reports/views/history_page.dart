import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedTeacher = ''; // Inicializamos con un valor vacío
  List<Map<String, dynamic>> _attendanceHistory = [];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final teachers = userProvider.userList.map((user) => user.name).toList();

    // Verifica y ajusta _selectedTeacher si es necesario
    if (_selectedTeacher.isEmpty && teachers.isNotEmpty) {
      _selectedTeacher =
          teachers.first; // Asigna el primer elemento como predeterminado
    } else if (!teachers.contains(_selectedTeacher)) {
      // Si _selectedTeacher no está en la lista, reinicia a un valor seguro
      _selectedTeacher = teachers.isNotEmpty ? teachers.first : '';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<String>(
            value: _selectedTeacher,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTeacher = newValue!;
                final selectedUser = userProvider.userList
                    .firstWhere((user) => user.name == newValue);
                _loadAttendanceData(selectedUser);
              });
            },
            items: teachers.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _attendanceHistory.length,
              itemBuilder: (context, index) {
                final entry = _attendanceHistory[index];
                final date = DateTime.parse(entry['date']);
                final formattedDate = DateFormat('dd MMM yyyy').format(date);
                final status = entry['status'];
                final arrivalTime = entry['arrival_time'] ?? 'N/A';

                return ListTile(
                  title: Text(formattedDate),
                  subtitle: Text('Status: $status\nArrival Time: $arrivalTime'),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  leading: Icon(
                    status == 'Present' ? Icons.check_circle : Icons.cancel,
                    color: status == 'Present' ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _loadAttendanceData(UserModel user) {
    setState(() {
      _attendanceHistory =
          []; // Limpiamos la lista antes de cargar nuevos datos
      if (user.attendances != null) {
        _attendanceHistory = user.attendances!.map((attendance) {
          DateTime parsedDate;

          // Verificar si la fecha tiene milisegundos
          if (attendance.createdAt!.contains(".")) {
            parsedDate = DateTime.parse(attendance.createdAt!);
          } else {
            // Añadir ".000000" para que el parseador DateTime lo reconozca correctamente
            parsedDate = DateTime.parse("${attendance.createdAt}.000000");
          }

          final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          final status = attendance.type == 'ATTENDANCE' ? 'Present' : 'Absent';
          final arrivalTime = attendance.type == 'ATTENDANCE'
              ? DateFormat('HH:mm:ss').format(parsedDate)
              : 'N/A';

          return {
            "date": formattedDate,
            "status": status,
            "arrival_time": arrivalTime,
          };
        }).toList();
      }
    });
  }
}
