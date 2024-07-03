import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class JustifiedVsUnjustifiedPage extends StatelessWidget {
  const JustifiedVsUnjustifiedPage({super.key});

  // Método para obtener los datos de asistencias justificadas y no justificadas
  List<Map<String, dynamic>> _getJustifiedVsUnjustifiedData() {
    // Datos simulados para el gráfico, incluyendo fechas
    return [
      {'date': 'sem 1', 'justificadas': 10, 'noJustificadas': 11},
      {'date': 'sem 2', 'justificadas': 12, 'noJustificadas': 8},
      {'date': 'sem 3', 'justificadas': 8, 'noJustificadas': 8},
      {'date': 'sem 4', 'justificadas': 9, 'noJustificadas': 10},
      {'date': 'sem 5', 'justificadas': 11, 'noJustificadas': 7},
      {'date': 'sem 6', 'justificadas': 13, 'noJustificadas': 6},
      {'date': 'sem 7', 'justificadas': 15, 'noJustificadas': 5},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final data = _getJustifiedVsUnjustifiedData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Green: Justificadas\nRed: No justificadas\nHorizontal: Semana\nVertical: Cantidad",
          style: TextStyle(fontSize: 10),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final entryData = entry.value;
                        return FlSpot(index.toDouble(),
                            entryData['justificadas'].toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                          show: true, color: Colors.green.withOpacity(0.1)),
                      barWidth: 4,
                    ),
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final entryData = entry.value;
                        return FlSpot(index.toDouble(),
                            entryData['noJustificadas'].toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.red,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                          show: true, color: Colors.red.withOpacity(0.1)),
                      barWidth: 4,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final style = const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          );
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              data[value.toInt()]['date'],
                              style: style,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final style = const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          );
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.toInt().toString(),
                              style: style,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.spotIndex;
                          return LineTooltipItem(
                            'Semana: ${data[index.toInt()]['date']}\nJustificadas: ${data[index.toInt()]['justificadas']}\nNo Justificadas: ${data[index.toInt()]['noJustificadas']}',
                            const TextStyle(color: Colors.black),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
