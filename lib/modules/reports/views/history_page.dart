import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedTeacher = 'Teacher 1';
  List<Map<String, dynamic>> _attendanceHistory = [];

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  void _loadAttendanceData() {
    // Datos fijos para dos profesores
    final data = {
      'Teacher 1': [
        {"date": "2024-07-15", "status": "Absent"},
        {"date": "2024-07-14", "status": "Present", "arrival_time": "08:06:00"},
        {"date": "2024-07-13", "status": "Present", "arrival_time": "08:04:00"},
        {"date": "2024-07-12", "status": "Present", "arrival_time": "08:15:00"},
        {"date": "2024-07-11", "status": "Absent"},
        {"date": "2024-07-10", "status": "Present", "arrival_time": "08:07:00"},
        {"date": "2024-07-09", "status": "Present", "arrival_time": "08:01:00"},
      ],
      'Teacher 2': [
        {"date": "2024-07-15", "status": "Present", "arrival_time": "08:00:00"},
        {"date": "2024-07-14", "status": "Absent"},
        {"date": "2024-07-13", "status": "Present", "arrival_time": "08:10:00"},
        {"date": "2024-07-12", "status": "Present", "arrival_time": "08:05:00"},
        {"date": "2024-07-11", "status": "Present", "arrival_time": "08:02:00"},
        {"date": "2024-07-10", "status": "Absent"},
        {"date": "2024-07-09", "status": "Present", "arrival_time": "08:03:00"},
      ],
    };

    setState(() {
      _attendanceHistory = data[_selectedTeacher] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<String>(
            value: _selectedTeacher,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTeacher = newValue!;
                _loadAttendanceData();
              });
            },
            items: <String>['Teacher 1', 'Teacher 2']
                .map<DropdownMenuItem<String>>((String value) {
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
}
