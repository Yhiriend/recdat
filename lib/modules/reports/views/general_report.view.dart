import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/reports/views/general_page.dart';
import 'package:recdat/modules/reports/views/history_page.dart';
import 'package:recdat/modules/reports/views/justified_vs_unjustified_page.dart';
import 'package:recdat/modules/reports/views/page_index_widget.dart';
import 'package:recdat/modules/reports/views/punctuality_page.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';

class GeneralReportView extends StatefulWidget {
  const GeneralReportView({super.key});

  @override
  State<GeneralReportView> createState() => _GeneralReportViewState();
}

class _GeneralReportViewState extends State<GeneralReportView> {
  List<Map<String, dynamic>> weeklyAttendanceData = [];
  List<Map<String, dynamic>> punctualityData = [];
  String currentMonthYear = '';
  int totalAttendanceCurrentMonth = 0;
  int _pageIndex = 0;
  String _title = "Reporte General";
  String _graphicTitle = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final now = DateTime.now();
    currentMonthYear = DateFormat('MMM yyyy').format(now);

    // Fetch data from Firestore
    await _fetchAttendanceData();
    await _fetchPunctualityData();

    setState(() {
      // Aquí se actualizarán los valores de weeklyAttendanceData y totalAttendanceCurrentMonth
      // una vez se obtengan los datos de Firestore
    });
  }

  Future<void> _fetchAttendanceData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final attendanceData = await userProvider.fetchMonthlyAttendanceData();

    // Procesar los datos obtenidos para calcular el total y los datos semanales
    totalAttendanceCurrentMonth = attendanceData.fold<int>(
        0, (sum, item) => (sum + item['attendances'].length) as int);
    weeklyAttendanceData = _calculateWeeklyAttendance(attendanceData);
    setState(() {
      _graphicTitle =
          'Month: $currentMonthYear\nTotal Attendances: $totalAttendanceCurrentMonth';
    });
    print(weeklyAttendanceData);
  }

  Future<void> _fetchPunctualityData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    punctualityData =
        await userProvider.calculatePunctualityData(authProvider.uid);
  }

  List<Map<String, dynamic>> _calculateWeeklyAttendance(
      List<Map<String, dynamic>> attendanceData) {
    Map<String, int> dailyData = {};

    for (var record in attendanceData) {
      record.forEach((key, value) {
        if (value is List) {
          for (var item in value) {
            if (item is Map && item.containsKey('entry_date')) {
              DateTime date = DateTime.parse(item['entry_date']);
              String dayOfMonth = DateFormat('dd').format(date);

              if (dailyData.containsKey(dayOfMonth)) {
                dailyData[dayOfMonth] = dailyData[dayOfMonth]! + 1;
              } else {
                dailyData[dayOfMonth] = 1;
              }
            }
          }
        }
      });
    }

    return dailyData.entries
        .map((entry) => {'day': entry.key, 'attendances': entry.value})
        .toList();
  }

  void _handlePageSelected(int index) {
    setState(() {
      _pageIndex = index;
      switch (index) {
        case 0:
          _title = "Reporte General";
          _graphicTitle =
              'Mes: $currentMonthYear\nAsistencias totales: $totalAttendanceCurrentMonth';
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
          _title = "Inasis. Justif. vs No-justif.";
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
        pageToShow = PunctualityPage();
        break;
      case 2:
        pageToShow = HistoryPage();
        break;
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
