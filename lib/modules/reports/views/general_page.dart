import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GeneralPage extends StatelessWidget {
  final String title;
  final String graphicTitle;
  final List<Map<String, dynamic>> weeklyAttendanceData;
  final int totalAttendanceCurrentMonth;

  const GeneralPage({
    required this.title,
    required this.graphicTitle,
    required this.weeklyAttendanceData,
    required this.totalAttendanceCurrentMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          graphicTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Text(
          textAlign: TextAlign.center,
          "eje x: días\neje y: Asistencias Totales",
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxY(), // Adjust this based on your data
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 0,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
                ),
              ),
              titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: _getLeftTitles,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: _getBottomTitles,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false))),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: const Color(0xff37434d),
                  width: 1,
                ),
              ),
              barGroups: _buildBarGroups(),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return weeklyAttendanceData.map((data) {
      final day = data['day'];
      final attendances = data['attendances'];
      return BarChartGroupData(
        x: int.parse(day), // Use the day as the x index
        barRods: [
          BarChartRodData(
            toY: attendances.toDouble(),
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    final day = value.toInt().toString().padLeft(2, '0');
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(day, style: style),
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    // Mostrar la etiqueta solo si es un número entero
    if (value % 1 == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(value.toInt().toString(), style: style),
      );
    } else {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child:
            Text("", style: style), // Mostrar cadena vacía si no es un entero
      );
    }
  }

  double _getMaxY() {
    // Find the maximum number of attendances to set maxY
    final maxAttendance = weeklyAttendanceData.fold<int>(0, (max, data) {
      final attendances = data['attendances'] as int;
      return attendances > max ? attendances : max;
    });
    return maxAttendance.toDouble() + 5; // Add some padding
  }
}
