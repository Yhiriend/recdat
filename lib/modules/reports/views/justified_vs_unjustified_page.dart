import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';

class JustifiedVsUnjustifiedPage extends StatelessWidget {
  const JustifiedVsUnjustifiedPage({Key? key});

  // Datos simulados para el gráfico, incluyendo fechas
  List<Map<String, dynamic>> _getJustifiedVsUnjustifiedData() {
    return [
      {'date': '1', 'justificadas': 6, 'noJustificadas': 4},
      {'date': '2', 'justificadas': 4, 'noJustificadas': 2},
      {'date': '3', 'justificadas': 7, 'noJustificadas': 3},
      {'date': '5', 'justificadas': 2, 'noJustificadas': 1},
      {'date': '6', 'justificadas': 6, 'noJustificadas': 4},
      {'date': '7', 'justificadas': 4, 'noJustificadas': 2},
      {'date': '8', 'justificadas': 7, 'noJustificadas': 3},
      {'date': '9', 'justificadas': 2, 'noJustificadas': 1},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🟢 Justificadas\n🔴 No justificadas\neje x: Semana\neje y: Cantidad",
          style: TextStyle(fontSize: 12),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: userProvider.fetchJustifiedVsUnjustifiedAttendance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final realData = snapshot.data ?? [];
              final simulatedData = _getJustifiedVsUnjustifiedData();

              // Combinar datos simulados con datos reales
              List<Map<String, dynamic>> combinedData = [
                ...simulatedData,
                ...realData
              ];

              return Column(
                children: [
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: combinedData.asMap().entries.map((entry) {
                              final index = entry.key;
                              final entryData = entry.value;
                              return FlSpot(index.toDouble(),
                                  entryData['justificadas'].toDouble());
                            }).toList(),
                            isCurved: true,
                            color: Colors.green,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                                show: true,
                                color: Colors.green.withOpacity(0.1)),
                            barWidth: 4,
                          ),
                          LineChartBarData(
                            spots: combinedData.asMap().entries.map((entry) {
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
                                    combinedData[value.toInt()]['date'],
                                    style: style,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
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
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
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
                                  'Semana: ${combinedData[index.toInt()]['date']}\nJustificadas: ${combinedData[index.toInt()]['justificadas']}\nNo Justificadas: ${combinedData[index.toInt()]['noJustificadas']}',
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
              );
            }
          },
        ),
      ),
    );
  }
}
