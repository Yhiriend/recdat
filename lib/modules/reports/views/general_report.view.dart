import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recdat/modules/reports/views/general_page.dart';
import 'package:recdat/modules/reports/views/history_page.dart';
import 'package:recdat/modules/reports/views/justified_vs_unjustified_page.dart';
import 'package:recdat/modules/reports/views/page_index_widget.dart';
import 'package:recdat/modules/reports/views/punctuality_page.dart';

class GeneralReportView extends StatefulWidget {
  const GeneralReportView({super.key});

  @override
  State<GeneralReportView> createState() => _GeneralReportViewState();
}

class _GeneralReportViewState extends State<GeneralReportView> {
  final List<Map<String, dynamic>> attendanceData = [
    // tu lista de datos de asistencia
  ];

  final List<Map<String, dynamic>> punctualityRecords = [
    // tu lista de registros de puntualidad
  ];

  late final List<Map<String, dynamic>> weeklyAttendanceData;
  late final List<Map<String, dynamic>> punctualityData;
  late final String currentMonthYear;
  late final int totalAttendanceCurrentMonth;
  int _pageIndex = 0;
  String _title = "Reporte General";
  String _graphicTitle = "";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentMonthYear = DateFormat('MMM yyyy').format(now);
    totalAttendanceCurrentMonth = _calculateTotalAttendanceForMonth();
    weeklyAttendanceData = _calculateWeeklyAttendance();
    punctualityData = _calculatePunctualityData();
  }

  int _calculateTotalAttendanceForMonth() {
    return 15;
  }

  List<Map<String, dynamic>> _calculateWeeklyAttendance() {
    List<Map<String, dynamic>> data = [
      {'day': 'Lunes', 'attendances': 10},
      {'day': 'Martes', 'attendances': 12},
      {'day': 'Miércoles', 'attendances': 8},
      {'day': 'Jueves', 'attendances': 15},
      {'day': 'Viernes', 'attendances': 11},
    ];
    return data;
  }

  List<Map<String, dynamic>> _calculatePunctualityData() {
    List<Map<String, dynamic>> data = [
      {'date': '2024-07-01', 'average_delay': 5.5},
      {'date': '2024-07-02', 'average_delay': 7.2},
      {'date': '2024-07-03', 'average_delay': 4.8},
      {'date': '2024-07-04', 'average_delay': 6.1},
      {'date': '2024-07-05', 'average_delay': 3.9},
    ];
    return data;
  }

  void _handlePageSelected(int index) {
    setState(() {
      _pageIndex = index;
      switch (index) {
        case 0:
          _title = "Reporte General";
          _graphicTitle =
              'Month: $currentMonthYear\nTotal Attendances: $totalAttendanceCurrentMonth';
          break;
        case 1:
          _title = "Reporte de Puntualidad";
          _graphicTitle =
              "Vertical: Retraso en minutos\nHorizontal: Día del mes";
          break;
        case 2:
          _title = "Histórico Asis. Individual";
          break;
        case 3:
          _title = "Asis. Justificadas vs No-justificadas";
          _graphicTitle = "justificadas vs no-justificadas";
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget pageToShow;
    switch (_pageIndex) {
      case 0:
        pageToShow = GeneralPage(
          title: _title,
          graphicTitle: _graphicTitle,
          weeklyAttendanceData: weeklyAttendanceData,
          totalAttendanceCurrentMonth: totalAttendanceCurrentMonth,
        );
        break;
      case 1:
        pageToShow = PunctualityPage(
          title: _title,
          graphicTitle: _graphicTitle,
          punctualityData: punctualityData,
        );
        break;
      case 2:
        pageToShow = HistoryPage();
      case 3:
        pageToShow = JustifiedVsUnjustifiedPage();
        break;
      default:
        pageToShow =
            Container(); // fallback, aunque este caso no debería ocurrir
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: Text("Descargar"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pageToShow,
      ),
      floatingActionButton: PageIndexWidget(
        onPageSelected: _handlePageSelected,
      ),
    );
  }
}
