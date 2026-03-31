import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:utfind/models/bulletin_model.dart';

class ComparisonChartScreen extends StatelessWidget {
  final List<BulletinSubject> subjects;

  const ComparisonChartScreen({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    // Filtrar apenas matérias que possuem pelo menos uma nota ou média da turma definida
    final printableSubjects = subjects.where((s) => 
      s.studentAverage != null || s.classAverage != null
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Desempenho vs Turma'),
      ),
      body: printableSubjects.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Aguardando lançamento de notas para gerar o comparativo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Média Global do Semestre',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 10,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${printableSubjects[groupIndex].name}\n',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: rodIndex == 0 ? 'Sua Média: ' : 'Média Turma: ',
                                    style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.normal),
                                  ),
                                  TextSpan(
                                    text: rod.toY.toStringAsFixed(1),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= printableSubjects.length) return const SizedBox.shrink();
                                final name = printableSubjects[value.toInt()].name;
                                // Abrevia o nome da matéria
                                final abrev = name.split(' ').where((s) => s.length > 2).map((s) => s[0]).join();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(abrev, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        barGroups: printableSubjects.asMap().entries.map((entry) {
                          int index = entry.key;
                          BulletinSubject s = entry.value;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: s.studentAverage ?? 0,
                                color: Colors.blueAccent,
                                width: 12,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                              BarChartRodData(
                                toY: s.classAverage ?? 0,
                                color: Colors.grey[400]!,
                                width: 12,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildLegend(),
                  const SizedBox(height: 16),
                  const Text(
                    '* As siglas no gráfico correspondem às iniciais das disciplinas.',
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem('Você', Colors.blueAccent),
        const SizedBox(width: 24),
        _legendItem('Turma', Colors.grey[400]!),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
