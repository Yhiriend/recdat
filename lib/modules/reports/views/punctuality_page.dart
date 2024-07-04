import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';

class PunctualityPage extends StatefulWidget {
  @override
  _PunctualityPageState createState() => _PunctualityPageState();
}

class _PunctualityPageState extends State<PunctualityPage> {
  List<Map<String, dynamic>> punctualityData = [];
  bool isLoading = false;
  String selectedTeacherId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUsers(context, authProvider.uid);
  }

  Future<void> fetchPunctualityData(String teacherId) async {
    setState(() {
      isLoading = true;
    });

    try {
      punctualityData = await calculatePunctualityData(teacherId);
    } catch (e) {
      print("Error fetching punctuality data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> calculatePunctualityData(
      String teacherId) async {
    List<Map<String, dynamic>> punctualityData = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final selectedTeacher =
          userProvider.userList.firstWhere((user) => user.uid == teacherId);

      List<dynamic> attendances = selectedTeacher.attendances ?? [];
      List<dynamic> entryAssignments = selectedTeacher.entryAssigments ?? [];

      DateTime now = DateTime.now();
      DateTime fifteenDaysAgo = now.subtract(Duration(days: 15));

      for (var attendance in attendances) {
        DateTime createdAt = DateTime.parse(attendance.createdAt.toString());
        if (createdAt.isAfter(fifteenDaysAgo)) {
          String dayOfWeek = DateFormat('EEEE').format(createdAt);
          String attendanceTimeStr = DateFormat('jm').format(createdAt);
          DateTime attendanceTime = DateFormat('jm').parse(attendanceTimeStr);

          for (var entry in entryAssignments) {
            if (entry['day'] == dayOfWeek) {
              String entryTimeStr = entry['hour'];
              if (entryTimeStr.isNotEmpty) {
                DateTime entryTime = DateFormat('jm').parse(entryTimeStr);
                int delayMinutes =
                    attendanceTime.difference(entryTime).inMinutes;
                if (delayMinutes < 0) {
                  delayMinutes = 0;
                }

                punctualityData.add({
                  'date': createdAt.toIso8601String(),
                  'average_delay': delayMinutes,
                });
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error calculating punctuality data: $e");
    }

    return punctualityData;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        if (userProvider.isLoading)
          CircularProgressIndicator()
        else
          DropdownButton<String>(
            value: selectedTeacherId.isEmpty ? null : selectedTeacherId,
            hint: Text('Select a Teacher'),
            onChanged: (String? newValue) {
              setState(() {
                selectedTeacherId = newValue!;
                fetchPunctualityData(selectedTeacherId);
              });
            },
            items:
                userProvider.userList.map<DropdownMenuItem<String>>((teacher) {
              return DropdownMenuItem<String>(
                value: teacher.uid,
                child: Text(teacher.name),
              );
            }).toList(),
          ),
        if (isLoading)
          CircularProgressIndicator()
        else
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: punctualityData.isEmpty
                    ? 0
                    : punctualityData
                            .map((e) => e['average_delay'] as double)
                            .reduce((a, b) => a > b ? a : b) +
                        10, // Add some padding
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 0,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final style = const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(value.toInt().toString(), style: style),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final style = const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            punctualityData.isNotEmpty
                                ? DateFormat('d').format(DateTime.parse(
                                    punctualityData[value.toInt()]['date']))
                                : '',
                            style: style,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color(0xff37434d),
                    width: 1,
                  ),
                ),
                barGroups: _buildPunctualityBarGroups(),
              ),
            ),
          ),
      ],
    );
  }

  List<BarChartGroupData> _buildPunctualityBarGroups() {
    return punctualityData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data['average_delay'].toDouble(),
            color: Colors.red,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}
